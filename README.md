# ACBTokenField <kbd><img src="/ACBTokenField/Resources/Assets.xcassets/AppIcon.appiconset/Icon-App-32x32@2x.png?raw=true" width="32"></kbd>

A swift extension on NSTokenField which makes it highly customizable and removes a lot of boiler plate code from its implementation.

## Features

 - [x] Extension on NSTokenField, no need to subclass/or change anything in XIB/Storyboard
 - [x] Added few properties which makes it customizable such as `shouldDisplayClearButton`, `shouldDisplaySearchIcon`, `leftView`, `shouldEnableTokenMenu` etc.. 
 - [x] No need to implement delegate methods for simpler use cases. Just set an array of token names list or provide a default list of tokens for all indices. Rest will be handled by `NSTokenField`. See demo provided below(1 - 3).
 - [x] Supports `NSTokenFieldDelegate` as well with the customization. Just set `tokenDelegate` and implement the methods(see gif4) as usual. 
 - [x] Added support for getting `selectedTokenIndex` so that tokens can be customized based on the index. `tokenIndex` provided in `NSTokenFieldDelegate` method has a bug and hence always returns zero. `selectedTokenIndex` will help in the meantime.
 - [x] Support for adding tokens
 - [x] Support for resetting tokens
 - [x] Get `tokenIndex` based on the `representedObject` param in delegate methods.
 
## Demo

<kbd><div><img src="/ACBTokenField/Screenshots/ACBTokenFieldGif1.gif?raw=true" width="500"></div></kbd>
<div><br></div>
<kbd><div><img src="/ACBTokenField/Screenshots/ACBTokenFieldGif2.gif?raw=true" width="500"></div></kbd>
<div><br></div>
<kbd><div><img src="/ACBTokenField/Screenshots/ACBTokenFieldGif3.gif?raw=true" width="500"></div></kbd>
<div><br></div>
<kbd><div><img src="/ACBTokenField/Screenshots/ACBTokenFieldGif4.gif?raw=true" width="500"></div></kbd>
<div><br></div>
<kbd><div><img src="/ACBTokenField/Screenshots/ACBTokenFieldGif5.gif?raw=true" width="500"></div></kbd>

<div><br></div>

## Quick start
Inorder to implement this in a project just copy the files `NSTokenField+ACBExtension.swift`, `ACBAssociation.swift`, `ACBToken.swift`and invoke the following function on any `NSTokenField`. As mentioned above, no need to subclass or change anything in XIB or Storyboard file

    tokenField.convertToACBTokenField()

If you would like to have clear button and/or search icon in tokenfield, you can copy the icons `ClearDarkGray` and `Glass` from Assets.xcassets. Otherwise you can use your own images and set the properties `clearIconName` and `searchIconName` of `NSTokenField`. You are good to go.

_Note: Cell class will be dynamically changed to `ACBTokenFieldCell` and `delegate` will be set. Please do not modify these properties. Use `tokenDelegate` instead of `delegate`._

## Setup

There are additional features which you can make use of such as setting an Array of token names list which represents token list at each index of token field. You don't have to implement the NSTokenField delegate in this case. This will take care of displaying suggestions/displaying menu on tokens/editing tokens etc. 

    tokenField.tokenKeywordsList = [["France", "Germany", "Italy", "USA", "Spain", "India", "Brazil"],
                                    ["Pizza", "Pasta", "Butter Chicken", "Jamon", "Cheesecake"],
                                    ["Deer", "Dog", "Bear", "Panda", "Jaguar", "Bull"],
                                    ["Car", "Truck", "Bus", "Motorcycle", "Minivan"]]
        
Set an array as shown above and it will show suggestions/menu based on the list above. Above list displays country names at index 0, food names at index 1, animal names at index 2 etc.. If you don't want to define token suggestions for each index separate like this, you can make use of below property to have default suggestions for all other indices except those present above.

    tokenField.defaultTokenKeywords = ["Red", "Blue", "Green", "White", "Purple", "Black"]
        
This will show default suggestions and token menu for all other tokens in tokenField whose index is not specified in `tokenKeywordsList`.

You can also set `leftView` property of token field to any `NSView` or subclass of `NSView`. For eg:- you can add an `NSButton` as `leftView` and have an action to set to it(See gif5).

#### Setting properties

    //set any required properties
    tokenField.shouldEnableTokenMenu = true
    tokenField.tokenDelegate = self
    tokenField.leftView = lockButton
        
#### Implement delegate

    public func tokenField(_ tokenField: NSTokenField, completionsForSubstring substring: String, indexOfToken tokenIndex: Int, indexOfSelectedItem selectedIndex: UnsafeMutablePointer<Int>?) -> [Any]? {
        switch tokenIndex {
            case 0:
                return actors
            case 1:
                return actresses
            case 2:
                return movies
            case 3:
                return years
            default:
                return nil
        }
    }



## Screenshots
<kbd><div><img src="/ACBTokenField/Screenshots/ACBTokenFieldImage1.png?raw=true" width="800"></div></kbd>

## License

MIT License

Copyright (c) 2017, Akhil C Balan(https://github.com/akhilcb)

All rights reserved.


