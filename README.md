# store-locator-iOS-sample
![alt text](https://github.com/mapfit/store-locator-iOS-sample/blob/master/StoreLocator-iOS.png)

## Features

- [x] Add locations to your map
- [x] Display information for each location

## Requirements

- iOS 11.0+
- Xcode 9

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `Mapfit` by adding it to your `Podfile`:

```ruby
platform :ios, '11.0'
use_frameworks!
pod 'Mapfit'
```

## Set your API Key

[Get an API Key](https://mapfit.com/getstarted)
```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      MFTManager.sharedManager.apiKey = "API_KEY"
      return true
    }
}

## Usage example

```swift
func loadData(){
//Create a point of interest location
let sampleLocation = POI(number: "1", address: "450 W 15th Street", city: "Manhattan", state: "NY", zipCode: "10014", primaryPhoneNumber: "(347) 387-7428", secondaryPhoneNumber: "(202) 555-0164", coordinate: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324), neighborhood: "Chelsea")

//add it to your map
locations.append(sampleLocation)
}
```
