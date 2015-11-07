source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'
gem 'unicorn'
# Component requirements
gem 'slim'
gem 'json'
gem 'rest-client'
# Test requirements

# Padrino Stable Gem
gem 'padrino', '0.12.2'

#redis
gem 'redis'
gem 'hiredis'
gem 'redis-activesupport'

gem 'pg'
gem "second_level_cache", :git => 'git://github.com/hooopo/second_level_cache.git', :ref => '8a8f591f1df2f20845d1aa4794737b78adf5f8c0'
gem 'acts-as-taggable-on', :git => "git://github.com/gdiplus/acts-as-taggable-on.git", :ref => 'fbb2f7466afeea31b6ffb7f434775adbf79ce019'
gem 'activerecord', '4.0.4', :require => 'active_record'
# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core support gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.12.2'
gem 'rack-weixin', :git =>'git://github.com/wolfg1969/rack-weixin.git' , :ref => 'a0e24e4fe8ce498b7d2c6be3f7218f30029f19a7'
# end

group :development do
  gem 'pry-padrino'
  gem 'padrino-gen', '0.12.2'
  gem 'thin'
end
