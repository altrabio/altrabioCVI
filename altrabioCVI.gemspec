# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{altrabioCVI}
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["L. Buffat & P.E. Jouve"]
  s.date = %q{2011-02-11}
  s.description = %q{This is a Work in Progress !
  Currently no documentation & tests, use it at your own risk...
  You will find here a solution that extends Single Table Inheritance & Class Table Inheritance.
  This solution is based on classical class inheritance, single table inheritance as well as DB views.
  This work is done @ altrabio. Find us @ http://wwww.altrabio.com}
  s.email = %q{laurent.buffat or pierre.jouve @nospam@ altrabio.com}
  s.extra_rdoc_files = ["lib/altrabioCVI.rb", "lib/altrabioCVI/acts_as_cvi.rb", "lib/altrabioCVI/core_ext.rb"]
  s.files = ["Manifest", "Rakefile", "gem-private_key.pem", "gem-public_cert.pem", "lib/altrabioCVI.rb", "lib/altrabioCVI/acts_as_cvi.rb", "lib/altrabioCVI/core_ext.rb", "altrabioCVI.gemspec", "test/my_test.rb", "test/test_helper.rb"]
  s.homepage = %q{https://github.com/testaltrabio1/altrabioCVI}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "altrabioCVI", "--main", "readmePEJ"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{altrabiocvi}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{This is a Work in Progress ! Currently no documentation & tests, use it at your own risk... You will find here a solution that extends Single Table Inheritance & Class Table Inheritance. This solution is based on classical class inheritance, single table inheritance as well as DB views. This work is done @ altrabio. Find us @ http://wwww.altrabio.com}
  s.test_files = ["test/my_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
