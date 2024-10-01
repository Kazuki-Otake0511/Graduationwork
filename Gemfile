source "https://rubygems.org"

gem "rails", "~> 7.2.1"
gem "sprockets-rails"
gem "sassc-rails"
gem "mysql2", "~> 0.5"
gem "puma", ">= 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false
gem "sorcery"
gem 'carrierwave', '~> 2.0'
gem 'mini_magick'

# Add Bootstrap
gem "bootstrap", "~> 5.1.0"  # ←ここに追加

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop", require: false  # ←ここに追加
end

group :development do
  gem "web-console"
  gem "better_errors"  # ←ここに追加
  gem "binding_of_caller"  # ←ここに追加
  gem "pry-rails"  # ←ここに追加
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end