
# CakeList

Cake list is an app which we would like to fetch some json from the internet, decode this into Cake objects, then present these in a UITableview. It needs to correctly handle cell reuse. It needs to correctly handle threading by having networking on an asynchronous thread and UI updates on the main thread.

### Considerations

Firstly, my goal was to identify the bug in the code to get to a functional app.

Secondly, I wanted to consider how the data was being loaded and displayed and whether this was actually being done in a way that was correct and scallable.

Finally, I wanted to consider the archetecture of the app in terms of what structural design pattern should be used, and look to perform a minimal refactoring of the app to make is conform to a chosen design pattern.

Overall, I wanted to ensure that the code was as closely as possible adhering to SOLID design principles, and designed in such a way as to facilitate future unit testing and UI testing.

### Tableview

What I noted initially was that a prototype cell had been created inside of the TableView in the main storyboard. Running the app lead to an error. Debugging this I noticed that the identifier defined in the storyboard did not match the code so this was corrected. Some of the image urls in the retrived json used http and not https so in our info.plist we added a key to allow arbitrary loads (although we would not typically want to do this in a production app since we would like all our resourses to use https as Apple recomends).

The next thing to do was to *separate out the tableview cell* from being nested in our storyboard, wbecause this then allows us to flexibly reuse the cell in other tableviews should we wish to.

A common challenge with tableview cells is arround cell re-use (being a mechanism tableviews use for efficiency) and we want to make sure that this is correctly handled. This can particularly be an issue where the data we want to show is not imediately avaliable, such as when we load it from a network.

We load images into our cells using Asychronous Networking, but we also need to make sure that when the asychrnous fetch completes, and the image is placed, this does not end up in the wrong place due to TableView's cell re-use mechanism.

## Separate out Business Logic from our View Layer

We don''t really want business logic to be inside our view controller, so we want to place our networking code into a separate class or layer of our application.

Our networking, and our View Modal (if we are using one), should therefore not be in our ViewController, and actually we want to aim to make the VC as small as we can as it's meant to just be for UI related stuff.

## Best Way to Handle Images in a Tableview
One really good (possibly the best way) to do this is using a really good library called SDWebImage: This handles the caching of images, and prioritising of fetching tasks for images for cells which are still on screen. What our app will not do this time is to cancel download operations for images for cells no longer on screen (such as where we have a large set of entirely different images). We could do this ourselves by subclassing NSOperation and cancelling checking and cancelling operations for those cells no longer on screen (this can also be used in combination with the prefeching methods). However, due to the scope of the task and limited time, I've decided to  stick to caching our images, and taking advantage of the way blocks capture object by value from there enclosing scope to ensure images don't get loaded into the wrong cell. Still we don't want to store data in our tableview cells as this is typically considered bad practice, but rather provide it from our tableview datasource.

For caching our images, we could use a NSCache, or just a custom data object. The advantage of the NSCache is we can easily limit it's size so that it kickes out less recent cached images when it runs out of space. Our native networking methods also have there own in build caching but caching the images ourselves stops us having to call any networking for stuff we already have.

Since the instructions suggest avoiding third party libraries, we can use simpler methods to ensure that the cell we're placing the image into will be the correct one. We can also define our own custom cache, or we can use the build in cache in  the likes NSURLSession (which we can also customise the settings for, such as the size of this build in cache).

## Future Improvements

One thing we might want to do is to change our Structural Design Pattern to an MVVM  pattern in the app. With Objective-C it might be natural to then use ReactiveCocoa to provide our biding layer between our ViewModel and view layers, although it's also possible to do something more lightweight.

To make the flow of our app more flexible, we could take out the storyboard segues and use the Coordinator Pattern to create an MVVM-C approch. This would be particularly useful in allowing our app to be expanded in future, and being able to flexibly change the flow of our application, and also facilitate looser coupling, and testability in our applications (in the same way as I seprated out our tableview cell to allow it to be used anywhere, we want to be decoupling our View Controllers, and also allowing for dependency injection also to facilitate loose coupling and better testability and to avoid spaghetti code).

Unit Testing could be enhanced in the app, to then potentially used with C.I. & C.D. tools when updating our application.

## The Instructions

***
NOTE: PLEASE DO NOT USE THIRD PARTY LIBRARIES. However, feel free to state which third party libraries you might have used.
***

Here you'll find the code for a simple mobile app to browse cakes.

Unfortunately, the developer who wrote this code is no longer employed by the company as we had some concerns over his ability.

The project compiles but the app crashes as soon as it runs. The app loads a JSON feed containing a repeated list of cakes, with title, image and description from a URL, then displays the contents of the feed in a scrollable list.

We would like you to fix the crash bug, ensure the functionality of the app works as expected (all images display correctly on the table, all text is readable) and performs smoothly (ideally, this should be done without third party libraries). You should also refactor, optimise and improve the code where appropriate to use platform best practises.

Please note that we are not looking for perfection, but rather for a clean and pragmatic solution. This should include refactoring but shouldn’t be over engineered. The test can be completed in 2-3 hours; howerever, this is a not a limit. Feel free to spend more time on it if you wish.