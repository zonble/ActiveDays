# ActiveDays


Weizhong Yang (a.k.a zonble)

ActiveDays is a Swift module, which turns how active a user is in a week into events which could be sent to Analytics platforms such as Firebase, Microsoft AppCenter and so on.

## Usage

When we want to measure how our users are engaged with our app, we may want to know how many days are they using in a week - How many users use our app only for one day, or seven days a week?

For example, if we want to know how many days does a user launch our app, we may create an instance of ActiveDaysPerWeekCounter, and start a session

``` swift
    let activeDaysCounter = ActiveDaysPerWeekCounter(settingKey: "app-launch")
    activeDaysCounter.startNewSessionIfNoExitingOne()
```

Then, pass a date to the ActiveDaysPerWeekCounter instance, it will tell you if you should send an event or not.

``` swift
    let result = try! activeDaysCounter.commit(accessDate: Date())
    if case let .active(days) = result {
        // Send active days to your analytics platform here.
    }
```

## Installation

You can only install the extension with Swift Package Manager right now. Please add

``` swift
    // swift-tools-version:4.0

    import PackageDescription

    let package = Package(
        name: "YourTargetName",
        products: [
            .executable(name: "YourTargetName", targets: ["YourTargetName"])
        ],
        dependencies: [
            .package(url: "https://github.com/zonble/ActiveDays", .upToNextMinor(from: "1.0.0"))
        ],
        targets: [
            .target(name: "YourTargetName", dependencies: ["ActiveDays"], path: "./Path/To/Your/Sources")
        ]
    )
```

Enjoy!