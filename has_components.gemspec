# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_components}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Maddox"]
  s.date = %q{2009-01-08}
  s.description = %q{TODO}
  s.email = %q{pat.maddox@gmail.com}
  s.files = ["VERSION.yml", "lib/has_components.rb", "spec/db", "spec/db/schema.rb", "spec/has_components_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/pat-maddox/has_components}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
