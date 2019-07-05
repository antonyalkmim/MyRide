# 🚕 MyRide (mytaxi-mobile-test)

An iOS app that shows taxi drivers within a map.

----

## Requirements
1. Xcode 10.12.1
2. Swift 5
3. Cocoapods version `1.7.3`

## Getting Started
1. Clone this repository
2. Run `pod install`
3. Run project 🎉

## Architecture

This app conforms to [**MVVM** (Model-View-ViewModel)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) patter to help us with unit tests and [Coordinators](https://will.townsend.io/2016/an-ios-coordinator-pattern) which is responsible for the application's navigation flow.

### Dependencies
> All of dependencies and third libraries used in this project as well as its versions can be found in [Podfile](https://github.com/antonyalkmim/MyRide/blob/master/Podfile).

- [SwiftLint](https://github.com/realm/SwiftLint) to maintain a good code quality.
- [SwiftGen](https://github.com/SwiftGen/SwiftGen) to generate a type-safe reference for resources (Localizable.strings and Assets).
- [RxSwift/RxCocoa](https://github.com/ReactiveX/RxSwift) to bind views and reactive code
- [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) to bind viewModels on tableView

## TO-DO
- [ ] Add continuous integration to run tests
- [ ] Improve UI/UX
- [ ] Add more tests and increase code coverage percentage
- [ ] Add UI tests
- [ ] Add support for more languages
- [ ] Add support for iPad
- [ ] Add A11n for accessibility

# License
----

```
The MIT License (MIT)

Copyright (c) 2019 Antony Alkmim

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

> Special thanks for [flaticon](https://www.flaticon.com) for the free assets.