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

> Special thanks for [flaticon](https://www.flaticon.com) for the free assets.