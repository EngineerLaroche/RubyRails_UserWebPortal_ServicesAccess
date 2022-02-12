source 'https://rubygems.org'

#**************************************************************
# Gem General
#**************************************************************
gem 'rspec', :require => false, :group => :test
gem 'simplecov', :require => false, :group => :test
gem 'simplecov-json',:require => false, :group => :test
gem 'coveralls',require: false
gem 'simplecov-rcov',:require => false, :group => :test

gem 'rails',                   '5.1.4'
gem 'bcrypt',                  '3.1.12'
gem 'faker',                   '1.7.3'
gem 'carrierwave',             '1.2.2'
gem 'mini_magick',             '4.7.0'
gem 'will_paginate',           '3.1.6'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'bootstrap-sass',          '3.3.7'
gem 'puma',                    '5.6.2'
gem 'sass-rails',              '5.0.6'
gem 'uglifier',                '3.2.0'
gem 'coffee-rails',            '4.2.2'
gem 'jquery-rails',            '4.3.1'
gem 'turbolinks',              '5.0.1'
gem 'jbuilder',                '2.7.0'
gem 'coffee-script-source',    '=1.12.2'
#gem 'heroku-deflater',         '0.6.3'
gem 'rack-timeout',            '0.4.2'
gem 'rails_12factor',          '0.0.3'

gem 'audited'
#gem 'heroku'
gem 'language-converter'
gem 'acts_as_follower', github: 'tcocca/acts_as_follower', branch: 'master'
gem 'attr_encrypted'


#**************************************************************
# Gem Developpement et Test
#**************************************************************
group :development, :test,:production do
  gem 'sqlite3', '1.3.13'
  gem 'railroady'
  gem 'byebug',  '9.0.6', platform: :mri
end

#**************************************************************
# Gem Developpement
#**************************************************************
group :development do
  gem 'web-console',           '3.5.1'
  gem 'listen',                '3.1.5'
  gem 'spring'                
  gem 'spring-watcher-listen'
  gem 'rails-erd'
end

#**************************************************************
# Gem Test
#**************************************************************
group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.14.1'
  gem 'guard-minitest',           '2.4.6'
  gem "json", RUBY_VERSION.start_with?("1.") ? "~> 1.8" : "~> 2.0"
end

#**************************************************************
# Gem Production
#**************************************************************
group :production do
  gem 'pg',  '0.20.0'
  gem 'fog', '1.42'
end
