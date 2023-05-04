Pod::Spec.new do |s|

  s.name             = "Verifone2CO"
  s.version          = "1.0.0"
  s.summary          = "Accept payments through Verifone2CO."
  s.description      = <<-DESC
                       The Verifone2CO library will allow you to accept payments in your iOS app.
  DESC
  s.homepage         = "https://www.verifone.com/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = "Verifone"
  s.source           = { :git => "https://gitlab.avangate.local/connectors/2checkout-ios-sdk.git", :tag => s.version.to_s }

  s.platform         = :ios, "11.0"
  s.swift_version    = "5.0"
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.source_files   = "Verifone2CO/**/*.{h,swift}"
  s.resources = ["Verifone2CO/**/*.{lproj,xcassets,storyboard}"]
  s.public_header_files = "Verifone2CO/*.{h}"
  s.header_dir = "Verifone2CO"
end
