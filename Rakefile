# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")

require 'motion/project/template/ios'
require 'guard/motion'
require 'formotion'
require 'sugarcube-repl'
require 'bundler'
require 'yaml'
require 'ParseModel'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Okonawa'

  app.sdk_version = '7.1'
  app.deployment_target = '7.1'

  # Set motion-my_env file
  app.my_env.file = './config/environment.yaml'

  # Also manually load file to access properties in the Rakefile
  vars_yaml = File.read './config/environment.yaml'
  vars_data = YAML.load vars_yaml

  app.frameworks += [
    'AudioToolbox',
    'CFNetwork',
    'CoreGraphics',
    'CoreLocation',
    'MobileCoreServices',
    'QuartzCore',
    'Security',
    'StoreKit',
    'SystemConfiguration'
  ]

  # in case app.deployment_target < '6.0'
  app.weak_frameworks += [
    'Accounts',
    'AdSupport',
    'Social'
  ]

  app.vendor_project('vendor/Parse.framework', :static,
    :products => ['Parse']
  )

  app.pods do
    pod 'Facebook-iOS-SDK', '~> 3.13.0'
    pod 'SVPullToRefresh', '~> 0.4.1'
  end

  app.info_plist['FacebookAppID'] =  vars_data['facebook_app_id']
  app.info_plist['URL types'] = { 'URL Schemes' => vars_data['facebook_app_url_types'] } # note the "fb" prefix
end
