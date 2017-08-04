# ACBTokenField
A swift extension on NSTokenField which makes it highly customizable and removes a lot of boiler plate code from implementation

Inorder to implement this in a project just copy the files `NSTokenField+ACBExtension.swift`, `ACBAssociation.swift`, `ACBToken.swift`and invoke the following function on any `NSTokenField`. No need to subclass or change class in Xib file(Note that the cell class will be dynamically changed to `ACBTokenFieldCell`). 

    tokenField.convertToACBTokenField()

If you would like to have clear button and/or search icon in tokenfield, you can copy the icons `ClearDarkGray` and `Glass` from Assets.xcassets. Or you can use your own images and set the properties `clearIconName` and `searchIconName` of NSTokenField. You are good to go.

There are additional features which you can make use of such as just setting an Array of token names list which represents token list at each index of token field. You don't have to implement the NSTokenField delegate in this case.

    tokenField.tokenKeywordsList = [["France", "Germany", "Italy", "USA", "Spain", "India", "Brazil"],
                                    ["Pizza", "Pasta", "Butter Chicken", "Jamon", "Cheesecake"],
                                    ["Deer", "Dog", "Bear", "Panda", "Jaguar", "Bull"],
                                    ["Car", "Truck", "Bus", "Motorcycle", "Minivan"]]
        
Just set an array as shown above and it will show suggestions based on the list above. If you don't want to define token suggestions for each index separate, you can make use of below property.

    tokenField.defaultTokenKeywords = ["Red", "Blue", "Green", "White", "Purple", "Black"]
        
This will show default suggestions and token menu for all tokens in token field.

You can also set `leftView` property of token field to any `NSView`. You can also add an `NSButton` and have an action to set to it.

