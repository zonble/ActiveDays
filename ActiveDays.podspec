#
# Be sure to run `pod lib lint ActiveDays.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ActiveDays'
  s.version          = '0.1.0'
  s.summary          = 'ActiveDays helps to know how many days users are using your app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  ActiveDays helps to know how many days users are using your app, by turning into active days into events that you can send to analytics platforms.
                       DESC

  s.homepage         = 'https://github.com/zonble/ActiveDays'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zonble' => 'zonble@gmail.com' }
  s.source           = { :git => 'https://github.com/zonble/ActiveDays.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zonble'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Sources/**/*'
  
end
