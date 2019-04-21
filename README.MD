
# CakeList

Cake list is an app which we would like to go fetch some json data from the internet, to then decode this into Cake objects (representing a given cake in an OO manner), then to go ahead and present these in a UITableview. It needs to correctly handle cell reuse in the TableView. Furthermore, the app should correctly handle threading by having networking on an asynchronous thread and UI updates on the main thread.

### Considerations

**Firstly**, my primary goal was to **identify the bug** in the code to get the app compiling and running.

**Secondly**, I wanted to consider how the data was being loaded and displayed and whether this was actually being done in a way that was correct and scalable.

**Finally**, it was important to think about the architecture of the app in terms of what **Structural Design Pattern** (Like MVC, MVVM, VIPER) should be used, and look to perform a minimal refactoring of the app to make is conform to a chosen design pattern.

Overall, I wanted to ensure that the code was as closely as possible adhering to **SOLID design principles**, and designed in such a way as to facilitate future unit testing and UI testing.

### Tableview

What I noted initially was that a prototype cell had been created inside of the TableView in the main storyboard. Running the app lead to an error. Debugging this I noticed that the identifier defined in the storyboard did not match the code so this was corrected. Some of the image urls in the retrieved json used http and not https so in our info.plist we added a key to allow arbitrary loads (although we would not typically want to do this in a production app since we would like all our resources to use https as Apple recommends).

The next thing to do was to **separate out the tableview cell** from being nested in our storyboard, because this will allow us to flexibly reuse the cell in other tableviews should we wish to.

A common challenge with tableview cells is around **cell re-use** (being a mechanism tableviews use for efficiency) and we want to make sure that this is correctly handled. This can particularly be an issue where the data we want to show is not immediately available, such as when we load it from a network.

We load images into our cells using Asynchronous Networking, but we also need to make sure that when the asynchronous fetch completes, and the image is placed, this does not end up in the wrong place due to TableView's cell re-use mechanism.

## Separate out Business Logic from our View Layer
We don''t really want business logic to be inside our view controller, so we want to place our networking code into a separate class or layer of our application. (If we used an MVVM approach a view model with reactive binding might be a way to do this).

Our networking, and our View Modal (if we are using one), should therefore not be in our ViewController, and actually we want to aim to make the VC as small as we can as its meant to just be for UI related stuff.

I've ended up with a broadly MVC approach but with some of the business logic separated out (so threfore I was looking to move in the direction of MVVM through SOLID principles application).

## Best Way to Handle Images in a Tableview
One really good to handle images for a tableview  is using a really good library called SDWebImage: This handles the caching of images, and prioritising of fetching tasks for images for cells which are still on screen.

What our app will not do this time is to cancel download operations for images for cells no longer on screen (such as where we have a large set of entirely different images). We could do this ourselves by subclassing NSOperation and cancelling checking and cancelling operations for those cells no longer on screen (this can also be used in combination with the prefetching methods). However, due to the scope of the task and limited time, I've decided to  stick to caching our images, and taking advantage of the way **Objective-C blocks capture objects by value** from there enclosing scope to ensure images don't get loaded into the wrong cell (we know the index path for the requested image is the same as where we're loading it).

A common problem in a Swift implementation might be where a closure captures a something by reference but completes asynchronously leading to the famous flickering incorrect image bug in a tableview with images.

Still we don't want to store data in our tableview cells as this is typically considered bad practice, but rather provide it from our tableview datasource.

For caching our images, we could use a NSCache, or just a custom data object. The advantage of the NSCache is we can easily limit it's size so that it kicks out less recent cached images when it runs out of space. Our native networking methods also have their own in build caching but caching the images ourselves stops us having to call any networking for stuff we already have.

Since the instructions suggest avoiding third party libraries, we can use simpler methods to ensure that the cell were placing the image into will be the correct one. We can also define our own custom cache, or we can use the build in cache in  the likes NSURLSession (which we can also customise the settings for, such as the size of this build in cache).

## Future Improvements

One thing we might want to do is to change our Structural Design Pattern to an MVVM  pattern in the app. With Objective-C it might be natural to then bring in some **FRP** with **ReactiveCocoa** to provide our biding layer between our ViewModel and view layers, although it's also possible to do something more lightweight especially as we don't really anticipate the cake json data changing regurlarly, and don't currently have a search box or filters which would make FRP more useful.

To make the **Flow of our App** more flexible, we could take out the storyboard segues and use the **Coordinator Pattern** to create an **MVVM-C** approach. This would be particularly useful in allowing our app to be expanded in future, and being able to flexibly change the flow of our application, and also facilitate looser coupling, and testability in our applications (in the same way as I separated out our tableview cell to allow it to be used anywhere, we want to be decoupling our View Controllers, and also allowing for dependency injection, and also to facilitate loose coupling and better testability, therefore avoid spaghetti code).

**Unit Testing** could be enhanced in the app, and then potentially used with C.I. & C.D. tools when updating our application. We could go further to use**protocols** to define common interfaces for objects like networking (like we might often do in Swift), allowing us to, for example, easily **Mock** classes that looks like a networking object but which is, in reality, fetching data from some local json (or hard coded) and returning this after a delay.

Some improvement of how dependencies are handled could be done to allow for **Dependency Injection** to be used in a way that does make our app more reconfigurable and testable. (I haven't used a lot of D.I. in Objective-C contexts to date due to a recent focus of my work in the Swift language).

We could absolutly have used a mixture of Objective-C and Swift in this app, or it would further have been easy enough to re-code the app fully in Swift (however this was beyond the scope of the coding test).

## The Instructions

***
NOTE: PLEASE DO NOT USE THIRD PARTY LIBRARIES. However, feel free to state which third party libraries you might have used.
***

Here you'll find the code for a simple mobile app to browse cakes.

Unfortunately, the developer who wrote this code is no longer employed by the company as we had some concerns over his ability.

The project compiles but the app crashes as soon as it runs. The app loads a JSON feed containing a repeated list of cakes, with title, image and description from a URL, then displays the contents of the feed in a scrollable list.

We would like you to fix the crash bug, ensure the functionality of the app works as expected (all images display correctly on the table, all text is readable) and performs smoothly (ideally, this should be done without third party libraries). You should also refactor, optimise and improve the code where appropriate to use platform best practices.

Please note that we are not looking for perfection, but rather for a clean and pragmatic solution. This should include refactoring but shouldn’t be over engineered. The test can be completed in 2-3 hours; however, this is a not a limit. Feel free to spend more time on it if you wish.
