# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'json'
require 'rack-weixin'


Bundler.require(:default, RACK_ENV)
WX_ACCOUNT = YAML.load_file(File.expand_path("#{PADRINO_ROOT}/config", __FILE__) + '/weixin_account.yml')[RACK_ENV]
MENU = YAML.load_file(File.expand_path("#{PADRINO_ROOT}/config", __FILE__) + '/menu_config.yml')[RACK_ENV]
Weixin::Menu.new(WX_ACCOUNT['appid'],WX_ACCOUNT['appsecret']).add(MENU)
WEIXIN_CLIENT = Weixin::Client.new(WX_ACCOUNT['appid'],WX_ACCOUNT['appsecret'])
if RACK_ENV == 'production'
  UPHOST = '5tv.com'
  LocalServer = '106.187.35.209'
  APISERVER = 'api.5tv.com'
else
  UPHOST =  '54.223.162.137:9999'
  LocalServer = '104.237.155.77'
  APISERVER = '54.223.162.137'
end

REDIS_CONFIG = YAML.load_file(File.expand_path("#{PADRINO_ROOT}/config", __FILE__) + '/redis.yml')[RACK_ENV]
CACHE = ActiveSupport::Cache::RedisStore.new :host => REDIS_CONFIG['host'], :driver => :hiredis, :expires_in => 1.hour

##
# ## Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure your I18n
#
# I18n.default_locale = :en
# I18n.enforce_available_locales = false
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
  I18n.default_locale = 'zh_cn'
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

Padrino.load!
