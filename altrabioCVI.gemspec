# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{altrabioCVI}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["L. Buffat & P.E. Jouve"]
  s.date = %q{2011-02-04}
  s.description = %q{A gem that extends STI as well as CTI, it proposes to have Class Inheritance and Table Inheritance thanks to views }
  s.email = %q{laurent.buffat or pierre.jouve @nospam@ altrabio.com}
  s.extra_rdoc_files = ["lib/altrabioCVI.rb", "lib/altrabioCVI/acts_as_cvi.rb", "lib/altrabioCVI/core_ext.rb"]
  s.files = ["Manifest", "Rakefile", "gem-private_key.pem", "gem-public_cert.pem", "lib/altrabioCVI.rb", "lib/altrabioCVI/acts_as_cvi.rb", "lib/altrabioCVI/core_ext.rb", "altrabioCVI.gemspec"]
  s.homepage = %q{https://github.com/testaltrabio1/altrabioCVI}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "altrabioCVI", "--main", "readmePEJ"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{altrabiocvi}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A gem that extends STI as well as CTI, it proposes to have Class Inheritance and Table Inheritance thanks to views}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
