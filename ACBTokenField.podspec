Pod::Spec.new do |s|
  s.name         = "ACBTokenField"
  s.version      = "2.0"
  s.summary      = "A swift extension on NSTokenField which makes it highly customizable and removes a lot of boilerplate code from implementation."
  s.description  = <<-DESC
  A swift extension on NSTokenField which makes it highly customizable and removes a lot of boilerplate code from implementation.
                   DESC
  s.homepage     = "https://github.com/akhilcb/ACBTokenField"
  s.license      = "MIT"
  s.author    	 = "Akhil"
  s.platform     = :osx, '10.12'
  s.source       = { :git => "https://github.com/akhilcb/ACBTokenField.git", :tag => "2.0" }
  s.source_files  = "ACBTokenField", "ACBTokenField/Classes/Source/**/*.{swift}"
  s.resources = "ACBTokenField/Resources/Assets.xcassets"
end
