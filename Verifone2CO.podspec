Pod::Spec.new do |s|

  s.name             = "Verifone2CO"
  s.version          = "1.1.0"
  s.summary          = "Accept payments through Verifone2CO."
  s.description      = <<-DESC
                       The Verifone2CO library will allow you to accept payments in your iOS app.
  DESC
  s.homepage         = "https://www.verifone.com/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = "Verifone"
  s.source           = { :git => "https://github.com/2Checkout/2checkout-ios-sdk", :tag => s.version.to_s }

  s.platform         = :ios, "11.0"
  s.swift_version    = "5.0"

  s.source_files   = "Verifone2CO/**/*.{h,swift}"
  s.resource_bundles = { 'Verifone2CO' => ["Verifone2CO/**/*.{lproj,xcassets,storyboard}"] }
  s.public_header_files = "Verifone2CO/*.{h}"
  s.header_dir = "Verifone2CO"
end
