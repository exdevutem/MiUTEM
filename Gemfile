source "https://rubygems.org"

gem "fastlane"
gem "cocoapods", :git => "https://github.com/CocoaPods/CocoaPods.git"
gem "abbrev"
gem "pry"

plugins_path = File.join(File.dirname(__FILE__), "fastlane", "PluginFile")
eval_gemfile(plugins_path) if File.exist?(plugins_path)