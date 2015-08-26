# -*- encoding: utf-8 -*-
# stub: ampel_extase 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ampel_extase"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Florian Frank"]
  s.date = "2015-08-26"
  s.description = "Library to control the build traffic light. Yes, we can\u{2026}"
  s.email = "flori@ping.de"
  s.executables = ["ampel_control"]
  s.extra_rdoc_files = ["README.md", "lib/ampel_extase.rb", "lib/ampel_extase/build_state.rb", "lib/ampel_extase/controller.rb", "lib/ampel_extase/jenkins_client.rb", "lib/ampel_extase/jenkins_state_observer.rb", "lib/ampel_extase/light_switcher.rb", "lib/ampel_extase/version.rb"]
  s.files = [".gitignore", ".utilsrc", "Gemfile", "README.md", "Rakefile", "VERSION", "ampel_extase.gemspec", "bin/ampel_control", "lib/ampel_extase.rb", "lib/ampel_extase/build_state.rb", "lib/ampel_extase/controller.rb", "lib/ampel_extase/jenkins_client.rb", "lib/ampel_extase/jenkins_state_observer.rb", "lib/ampel_extase/light_switcher.rb", "lib/ampel_extase/version.rb", "spec/ampel_extase/build_state_spec.rb", "spec/ampel_extase/controller_spec.rb", "spec/ampel_extase/jekins_state_observer_spec.rb", "spec/ampel_extase/jenkins_client_spec.rb", "spec/ampel_extase/light_switcher_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/flori/ampel_extase"
  s.licenses = ["GPL-2"]
  s.rdoc_options = ["--title", "AmpelExtase - Library to control the build traffic light", "--main", "README.md"]
  s.rubygems_version = "2.4.8"
  s.summary = "Library to control the build traffic light"
  s.test_files = ["spec/ampel_extase/build_state_spec.rb", "spec/ampel_extase/controller_spec.rb", "spec/ampel_extase/jekins_state_observer_spec.rb", "spec/ampel_extase/jenkins_client_spec.rb", "spec/ampel_extase/light_switcher_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 1.3.1"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.9"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<byebug>, [">= 0"])
      s.add_development_dependency(%q<codeclimate-test-reporter>, [">= 0"])
      s.add_runtime_dependency(%q<tins>, ["~> 1.0"])
      s.add_runtime_dependency(%q<term-ansicolor>, ["~> 1.0"])
      s.add_runtime_dependency(%q<socket_switcher>, [">= 0"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 1.3.1"])
      s.add_dependency(%q<simplecov>, ["~> 0.9"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<byebug>, [">= 0"])
      s.add_dependency(%q<codeclimate-test-reporter>, [">= 0"])
      s.add_dependency(%q<tins>, ["~> 1.0"])
      s.add_dependency(%q<term-ansicolor>, ["~> 1.0"])
      s.add_dependency(%q<socket_switcher>, [">= 0"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 1.3.1"])
    s.add_dependency(%q<simplecov>, ["~> 0.9"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<byebug>, [">= 0"])
    s.add_dependency(%q<codeclimate-test-reporter>, [">= 0"])
    s.add_dependency(%q<tins>, ["~> 1.0"])
    s.add_dependency(%q<term-ansicolor>, ["~> 1.0"])
    s.add_dependency(%q<socket_switcher>, [">= 0"])
  end
end
