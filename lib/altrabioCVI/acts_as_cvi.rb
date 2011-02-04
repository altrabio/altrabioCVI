module Cvi
  
  def self.included(base) 
    #When a class includes a module the module’s self.included method will be invoked.
    base.send :extend, ClassMethods
  end


#A AMELIORER PB framework development, production, test


 
#------------------------------------------------------------------------------------------------------------------------ 
#
#             methods that will be used for the class
#
#------------------------------------------------------------------------------------------------------------------------

  module ClassMethods
    # any method placed here will apply to classes
    

    def acts_as_cvi(options = {}) 

        
        
        db_type_field = (options[:db_type_field] || :type).to_s         #:db_type_field = option for setting the inheritance columns, default value = 'type'
        table_name = (options[:table_name] || self.name.tableize).to_s  #:table_name = option for setting the name of the current class table_name, default value = 'tableized(current class name)'

        set_inheritance_column "#{db_type_field}"

        if(self.superclass!=ActiveRecord::Base)
          puts "acts_as_cvi -> NON mother class"
          set_table_name "view_#{table_name}"
          aaa=create_class_part_of self# these 2 lines are there for the creation of class PartOf (which is a class of the current class)
          self.const_set("PartOf",aaa) # it will stand for the self table of the current class
          set_table="#{table_name}"
        else
          puts "acts_as_cvi -> MOTHER class"
        
        


          def mother_class #give the mother class : the highest inherited class after ActiveRecord 
           if(self.superclass!=ActiveRecord::Base)  
              self.superclass.mother_class
            else
            return self 
            end
          end 


          def find(*args) #override find to get more informations        
            tuples = super
            return tuples if tuples.kind_of?(Array) # in case of several tuples just return the tuples as they are
            #tuples.reload2                         # reload2 is defined in lib/activerecord_ext.rb
            tuples.class.where(tuples.class[:id].eq(tuples.id))[0]  # in case of only one tuple return a reloaded tuple  based on the class of this tuple
                                                                  # this imply a "full" load of the tuple
                                                                  # AVOIR AVEC LB peut être préfère t il laisser reload2                                                        
          end


          def delete(id) #override delete to delete every pieces of information bout this record wherever it may be stored
            puts "delete de classe = #{self.name}"
            return super if self == self.mother_class #if the class of the record is the mother class then call with the id of the object
 
                                                          #if the class of the record is not the mother class then 

            if self.respond_to?('has_a_part_of') # eventually delete pieces of information stored in the table associated to the class of the object (if there is such a table)
              self::PartOf.delete(id)  if self.has_a_part_of?  
            end
            self.superclass.delete(id)                     # call the delete method associated to the super class of the current class with the id the object
          end  #A AMELIORER


          def delete_all
           # implementation plus rapide que un par un ? A MODIFIER
           self.all.each{|o| o.delete } #call delete method fo each object of the class
          end

          send :include, InstanceMethods     
        
        end

    end
  
  end  
 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
#------------------------------------------------------------------------------------------------------------------------
# 
#                 methods that will be used for the instance
#
#------------------------------------------------------------------------------------------------------------------------ 
 
  module InstanceMethods
  # any method placed here will apply to instances

  def save
#    return super if self.class == self.class.mother_class #if the class of the instance is the mother class then call A COMPLETER with the id of the instance
    if self.class == self.class.mother_class #if the class of the instance is the mother class then call A COMPLETER with the id of the instance
      ret=super
      
      #A AMELIORER le code ci dessous évite d'avoir des nil pour le champ type de la motherclass dans la table de la motherclass mais génère un update de trop !
      sql = "UPDATE #{self.class.mother_class.table_name} SET type = '#{self.class.to_s}' WHERE id = #{self.id}"
      puts "SQL : #{sql}"
      self.connection.execute(sql)
      
      return ret 
    end
    attributes_for_super = self.attributes.select{|key,value| self.class.superclass.column_names.include?(key) } #get the attributes of the class of the instance that also belong to its superclass 
    attributes_for_part_of = self.attributes.select{|key,value| !self.class.superclass.column_names.include?(key) } #get the attributes of the class of the instance that do not belong to its superclass
                                                                                                                    # these pieces of information should be stored in the table associated to the class of the instance
    herited = self.class.superclass.new(attributes_for_super)   #create a new instance of the superclass of the considered instance (self) 
    if(!new_record?)
        herited.swap_new_record
        herited.id = self.id
    end
    
    puts("herited save #{herited.class}")
    herited_saved = herited.saveBis # save the new instance (by calling its save method)
    
    if(herited_saved==false) 
      alert('please contact altrabio use the following mail : altrabio...altrabio.com') # que faire si herited_saved vaut false ? A VOIR
    end
    
    part_of_saved=true
    if( ! attributes_for_part_of.empty? ) #if there are some piecesof information to save in the table associated to the class of the cosidered instance
      part_of = self.class::PartOf.new(attributes_for_part_of) #A COMPLETER création nouvel objet partof renseigné
      part_of.id = herited.id
      
      if(!new_record?)
        part_of.swap_new_record
      end
        
      part_of_saved = part_of.save
      if(part_of_saved==false) 
        alert('please contact altrabio use the following mail : altrabio...altrabio.com') # que faire si herited_saved vaut false ? A VOIR
      end
     end

    
    self.id = herited.id
    puts "x : "
    sql = "UPDATE #{self.class.mother_class.table_name} SET type = '#{self.class.to_s}' WHERE id = #{self.id}"
    puts "SQL : #{sql}"
    self.connection.execute(sql)
    return herited_saved && part_of_saved 
  end


   def saveBis #Arnaque pour éviter 

      return save if self.class == self.class.mother_class #if the class of the instance is the mother class then call A COMPLETER with the id of the instance

      attributes_for_super = self.attributes.select{|key,value| self.class.superclass.column_names.include?(key) } #get the attributes of the class of the instance that also belong to its superclass 
      attributes_for_part_of = self.attributes.select{|key,value| !self.class.superclass.column_names.include?(key) } #get the attributes of the class of the instance that do not belong to its superclass
                                                                                                                      # these pieces of information should be stored in the table associated to the class of the instance
      herited = self.class.superclass.new(attributes_for_super)   #create a new instance of the superclass of the considered instance (self) 

      if(!new_record?)
          herited.swap_new_record
          herited.id = self.id
      end

      herited_saved = herited.saveBis # save the new instance (by calling its save method)

      if(herited_saved==false) 
        alert('please contact altrabio use the following mail : altrabio...altrabio.com') # que faire si herited_saved vaut false ? A VOIR
      end

      part_of_saved=true
      if( ! attributes_for_part_of.empty? ) #if there are some piecesof information to save in the table associated to the class of the cosidered instance
        part_of = self.class::PartOf.new(attributes_for_part_of) #A COMPLETER création nouvel objet partof renseigné
        part_of.id = herited.id

        if(!new_record?)
          part_of.swap_new_record
        end

        part_of_saved = part_of.save
        if(part_of_saved==false) 
          alert('please contact altrabio use the following mail : altrabio...altrabio.com') # que faire si herited_saved vaut false ? A VOIR
        end
       end

      self.id = herited.id

      return herited_saved && part_of_saved 
    end
    
    
     
   
   
   def delete   #call the class delete method with the id of the instance
     self.class.delete( self.id)
   end
   
   

  end
  
end  
  
  
  
  
  
  
  ActiveRecord::Base.send :include, Cvi 
