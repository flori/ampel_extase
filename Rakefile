# vim: set filetype=ruby et sw=2 ts=2:

require 'gem_hadar'

GemHadar do
  name        'ampel_extase'
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "http://github.com/flori/#{name}"
  summary     'Library to control the build traffic light'
  description "#{summary}. Yes, we can…"
  licenses    << 'GPL-2'
  test_dir    'spec'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', '.rvmrc', 'coverage',
    'tags', '.bundle', '.DS_Store', '.build'

  readme      'README.md'
  executables.merge Dir['bin/*'].map { |x| File.basename(x) }

  dependency             'tins',        '~>1.0'
  dependency             'socket_switcher'
  development_dependency 'simplecov',   '~>0.9'
  development_dependency 'rspec',       '~>3.0'
  development_dependency 'byebug'

  default_task_dependencies :spec
end
