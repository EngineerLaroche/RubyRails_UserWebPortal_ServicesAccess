# -*- encoding: utf-8 -*-
# stub: binarylogic-searchlogic 2.3.5 ruby lib

Gem::Specification.new do |s|
  s.name = "binarylogic-searchlogic"
  s.version = "2.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ben Johnson of Binary Logic"]
  s.date = "2009-09-13"
  s.description = "Searchlogic makes using ActiveRecord named scopes easier and less repetitive."
  s.email = "bjohnson@binarylogic.com"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/binarylogic/searchlogic"
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "searchlogic"
  s.rubygems_version = "2.5.2.1"
  s.summary = "Searchlogic makes using ActiveRecord named scopes easier and less repetitive."

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.0.0"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.0.0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.0.0"])
  end
end
