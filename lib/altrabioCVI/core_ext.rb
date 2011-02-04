#require 'ActiveRecord'
class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter #A COMPLETER
   def tables(name = nil)

     query(<<-SQL, name).map { |row| row[0] }
       SELECT tablename
       FROM pg_tables
       WHERE schemaname = ANY (current_schemas(false))
     SQL
     #AJOUT PEJ
      query(<<-SQL, name).map { |row| row[0] }
         SELECT viewname
           FROM pg_views
         WHERE schemaname = ANY (current_schemas(false))
       SQL
     #FIN AJOUT PEJ
   end

    def table_exists?(name)
       name          = name.to_s
       schema, table = name.split('.', 2)

       unless table # A table was provided without a schema
         table  = schema
         schema = nil
       end

       if name =~ /^"/ # Handle quoted table names
         table  = name
         schema = nil
       end

       query(<<-SQL).first[0].to_i > 0
            SELECT COUNT(*)
            FROM pg_tables
            WHERE tablename = '#{table.gsub(/(^"|"$)/,'')}'
            #{schema ? "AND schemaname = '#{schema}'" : ''}
        SQL
       #PEJ
        query(<<-SQL).first[0].to_i > 0
             SELECT COUNT(*)
             FROM pg_views
             WHERE viewname = '#{table.gsub(/(^"|"$)/,'')}'
             #{schema ? "AND schemaname = '#{schema}'" : ''}
         SQL
       
       
       
    end

end
 
 class ActiveRecord::Base  

   def reload #A COMPLETER
     self.class.find(self.id)
   end

   def self.[](column_name) #A COMPLETER
     arel_table[column_name]
   end
   
   def swap_new_record
        @persisted=!@persisted
   end

   def self.create_class_part_of(class_reference)

     def class_reference.has_a_part_of?
       return true
     end

     Class.new(ActiveRecord::Base) do
       set_table_name(class_reference.name.tableize)
     end
     # attention, la class crée est le retour de la fonction
     # Ne plus rien rajouter ici
   end


#   def reload2 #A VOIR totally useless now see with LB
#     self.class.where(self.class[:id].eq(self.id))[0]
#   end

 end
 
 class ActiveRecord::Migration

   def self.CreateTheViewForCVI(theclass)  #method for creating views for migrations A TESTER avec plusieurs SGBD
        puts "1 CreateTheViewForCVI"
        self_columns = theclass::PartOf.column_names.select{ |c| c != "id" } 
        puts "2"
        parent_columns = theclass.superclass.column_names.select{ |c| c != "id" }
     
        columns = parent_columns+self_columns
        puts "3"    
        self_read_table = theclass.table_name
        # eventuellement warning si pas de part_of
        self_write_table = theclass::PartOf.table_name
        parent_read_table = theclass.superclass.table_name
        puts "4"    
        # on a tous pour construire la requête SQL
        puts " self read table #{self_read_table} | parent_read_table #{parent_read_table}"
        sql = "CREATE VIEW #{self_read_table} AS SELECT #{parent_read_table}.id, #{columns.join(',')} FROM #{parent_read_table}, #{self_write_table} WHERE #{parent_read_table}.id = #{self_write_table}.id" 
        self.connection.execute sql
    end
    
    def self.DropTheViewForCVI(theclass) #method for dropping views for migrations A TESTER avec plusieurs SGBD
         puts "1 DropTheViewForCVI"
         self_read_table = theclass.table_name
         # on a tous pour construire la requête SQL
         puts " DROP VIEW #{self_read_table}"
         sql = "DROP VIEW #{self_read_table}" 
         self.connection.execute sql
    end
    
    
 end