$:.push File.expand_path("../lib", __FILE__)
require "kaminari-cache/version"

Gem::Specification.new do |s|
  s.name        = 'kaminari-cache'
  s.version     = KaminariCache::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Jim Durand']
  s.email       = ['powerjim@gmail.com']
  s.homepage    = 'https://github.com/jdurand/kaminari-cache'
  s.summary     = 'Kaminari Cache makes caching your Kaminari pagination a breeze'
  s.description = 'Kaminari Cache is a simple caching layer and sweeper for Kaminari pagination'

  s.rubyforge_project = 'kaminari-cache'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.rdoc']
  s.require_paths = ['lib']

  s.licenses = ['MIT']

  s.add_dependency 'activesupport', ['>= 3.0.0']
  s.add_dependency 'actionpack', ['>= 3.0.0']

  s.add_development_dependency 'bundler', ['>= 1.0.0']
  s.add_development_dependency 'rake', ['>= 0']
  s.add_development_dependency 'rspec', ['>= 0']
  s.add_development_dependency 'shoulda', ['>= 0']
  s.add_development_dependency 'capybara', ['>= 1.0']
  s.add_development_dependency 'rdoc', ['>= 0']
  s.add_development_dependency 'jeweler', ['~> 1.8.7']
  s.add_development_dependency 'rcov', ['>= 0']
end