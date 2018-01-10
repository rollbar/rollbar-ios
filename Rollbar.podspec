Pod::Spec.new do |s|
  s.name         = "Rollbar"
  s.version      = "1.0.0-alpha3"
  s.summary      = "Objective-C library for crash reporting and logging with Rollbar."
  s.description  = <<-DESC
    Find, fix, and resolve errors with Rollbar.
    Easily send error data using Rollbar's API.
    Analyze, de-dupe, send alerts, and prepare the data for further analysis.
    Search, sort, and prioritize via the Rollbar dashboard.
                   DESC

  s.homepage           = "https://rollbar.com"
  s.license            = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Rollbar" => "support@rollbar.com" }
  s.social_media_url   = "http://twitter.com/rollbar"
  s.platform           = :ios, "7.0"
  s.source             = { :git => "https://github.com/rollbar/rollbar-ios.git", :tag => "v1.0.0-alpha3" }
  s.source_files       = "Rollbar/*.{h,m}",
    "KSCrash/Source/KSCrash/**/*.{m,h,mm,c,cpp}"

  s.frameworks = "SystemConfiguration",
                 "MessageUI",
                 "UIKit",
                 "Foundation"
  s.libraries = "c++", "z"
  s.requires_arc = true
end
