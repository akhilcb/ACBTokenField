Pod::Spec.new do |s|
  s.name         = "ACBTokenField"
  s.version      = "2.2"
  s.summary      = "A swift extension on NSTokenField which makes it highly customizable and removes a lot of boilerplate code from implementation."
  s.description  = <<-DESC
  A swift extension on NSTokenField which makes it highly customizable and removes a lot of boilerplate code from implementation. Major features are: No need to subclass/or change anything in XIB/Storyboard. Added few properties which makes it customizable such as `shouldDisplayClearButton`, `shouldDisplaySearchIcon`, `leftView`, `shouldEnableTokenMenu` etc.. No need to implement delegate methods for simpler use cases. Just set an array of token names list or provide a default list of tokens for all indices. Rest will be handled by `NSTokenField`. Supports `NSTokenFieldDelegate` as well with the customization. Just set `tokenDelegate` and implement the methods as usual. Added support for getting `selectedTokenIndex` so that tokens can be customized based on the index. `tokenIndex` provided in `NSTokenFieldDelegate` method has a bug and hence always returns zero. `selectedTokenIndex` will help in the meantime. Support for adding tokens. Support for resetting tokens. Get `tokenIndex` based on the `representedObject` param in delegate methods.
                   DESC
  s.homepage     = "https://github.com/akhilcb/ACBTokenField"
  s.license      = "MIT"
  s.author    	 = "Akhil"
  s.platform     = :osx, '10.10'
  s.source       = { :git => "https://github.com/akhilcb/ACBTokenField.git", :tag => "2.2" }
  s.source_files  = "ACBTokenField", "ACBTokenField/Classes/Source/**/*.{swift}"
  s.resources = "ACBTokenField/Resources/Assets.xcassets"
end
