# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruby-debug-ide19"
  s.version = "0.4.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Markus Barchfeld, Martin Krauskopf, Mark Moseley"]
  s.date = "2009-10-01"
  s.description = "An interface which glues ruby-debug to IDEs like Eclipse (RDT) and NetBeans.\n"
  s.email = "mark@fast-software.com"
  s.executables = ["rdebug-ide"]
  s.files = ["bin/rdebug-ide"]
  s.homepage = "http://rubyforge.org/projects/ruby-debug19"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.2")
  s.rubyforge_project = "debug-commons"
  s.rubygems_version = "1.8.22"
  s.summary = "IDE interface for ruby-debug."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-debug-base19>, ["~> 0.11.20"])
    else
      s.add_dependency(%q<ruby-debug-base19>, ["~> 0.11.20"])
    end
  else
    s.add_dependency(%q<ruby-debug-base19>, ["~> 0.11.20"])
  end
end
