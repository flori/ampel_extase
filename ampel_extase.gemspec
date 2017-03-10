# -*- encoding: utf-8 -*-
# stub: ampel_extase 0.7.2 ruby lib

Gem::Specification.new do |s|
  s.name = "ampel_extase".freeze
  s.version = "0.7.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Florian Frank".freeze]
  s.date = "2017-03-10"
  s.description = "Library to control the build traffic light. Yes, we can\u2026".freeze
  s.email = "flori@ping.de".freeze
  s.executables = ["ampel_control".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "lib/ampel_extase.rb".freeze, "lib/ampel_extase/build_state.rb".freeze, "lib/ampel_extase/controller.rb".freeze, "lib/ampel_extase/jenkins_client.rb".freeze, "lib/ampel_extase/jenkins_state_observer.rb".freeze, "lib/ampel_extase/jenkins_warning_state_observer.rb".freeze, "lib/ampel_extase/light_switcher.rb".freeze, "lib/ampel_extase/semaphore_client.rb".freeze, "lib/ampel_extase/semaphore_state_observer.rb".freeze, "lib/ampel_extase/version.rb".freeze]
  s.files = [".gitignore".freeze, ".travis.yml".freeze, ".utilsrc".freeze, "Gemfile".freeze, "README.md".freeze, "Rakefile".freeze, "VERSION".freeze, "ampel_extase.gemspec".freeze, "bin/ampel_control".freeze, "lib/ampel_extase.rb".freeze, "lib/ampel_extase/build_state.rb".freeze, "lib/ampel_extase/controller.rb".freeze, "lib/ampel_extase/jenkins_client.rb".freeze, "lib/ampel_extase/jenkins_state_observer.rb".freeze, "lib/ampel_extase/jenkins_warning_state_observer.rb".freeze, "lib/ampel_extase/light_switcher.rb".freeze, "lib/ampel_extase/semaphore_client.rb".freeze, "lib/ampel_extase/semaphore_state_observer.rb".freeze, "lib/ampel_extase/version.rb".freeze, "spec/ampel_extase/build_state_spec.rb".freeze, "spec/ampel_extase/controller_spec.rb".freeze, "spec/ampel_extase/jekins_state_observer_spec.rb".freeze, "spec/ampel_extase/jenkins_client_spec.rb".freeze, "spec/ampel_extase/jenkins_warning_state_observer_spec.rb".freeze, "spec/ampel_extase/light_switcher_spec.rb".freeze, "spec/ampel_extase/semaphore_client_spec.rb".freeze, "spec/ampel_extase/semaphore_state_observer_spec.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "http://github.com/flori/ampel_extase".freeze
  s.licenses = ["GPL-2".freeze]
  s.rdoc_options = ["--title".freeze, "AmpelExtase - Library to control the build traffic light".freeze, "--main".freeze, "README.md".freeze]
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Library to control the build traffic light".freeze
  s.test_files = ["spec/ampel_extase/build_state_spec.rb".freeze, "spec/ampel_extase/controller_spec.rb".freeze, "spec/ampel_extase/jekins_state_observer_spec.rb".freeze, "spec/ampel_extase/jenkins_client_spec.rb".freeze, "spec/ampel_extase/jenkins_warning_state_observer_spec.rb".freeze, "spec/ampel_extase/light_switcher_spec.rb".freeze, "spec/ampel_extase/semaphore_client_spec.rb".freeze, "spec/ampel_extase/semaphore_state_observer_spec.rb".freeze, "spec/spec_helper.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>.freeze, ["~> 1.7.1"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<byebug>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<tins>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<term-ansicolor>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<socket_switcher>.freeze, [">= 0"])
    else
      s.add_dependency(%q<gem_hadar>.freeze, ["~> 1.7.1"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.9"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<byebug>.freeze, [">= 0"])
      s.add_dependency(%q<tins>.freeze, ["~> 1.0"])
      s.add_dependency(%q<term-ansicolor>.freeze, ["~> 1.0"])
      s.add_dependency(%q<socket_switcher>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<gem_hadar>.freeze, ["~> 1.7.1"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.9"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<byebug>.freeze, [">= 0"])
    s.add_dependency(%q<tins>.freeze, ["~> 1.0"])
    s.add_dependency(%q<term-ansicolor>.freeze, ["~> 1.0"])
    s.add_dependency(%q<socket_switcher>.freeze, [">= 0"])
  end
end
