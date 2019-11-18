# Fuzzywuzzy_swift
Fuzzywuzzy port in Swift using Levenshtein Distance.
Ported from the C# Fuzzywuzzy library
https://github.com/JakeBayer/FuzzySharp

It has no external dependencies. 
And thanks to Swift String, it support's multi-language.
But it only supports the Partial Ratio.

# Installation
### Cocoapod
Add the following line to your Podfile. And run `pod install`
```
pod 'Fuzzywuzzy_swift', :git=> 'https://github.com/swing7wing/Fuzzywuzzy_swift.git'
```
### Manually
drag the `Fuzzywuzzy_swift` folder into your project

# Usage
```swift
import Fuzzywuzzy_swift
```

### Partial Ratio
Partial Ratio tries to match the shorter string to a substring of the longer one
```swift
String.fuzzPartialRatio(str1: "some text here", str2: "I found some text here!") // => 100
```
