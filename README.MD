Coding Test (fictitious)


***
NOTE: PLEASE DO NOT USE THIRD PARTY LIBRARIES. However, feel free to state which third party libraries you might have used.
***

Here you'll find the code for a simple mobile app to browse cakes.

Unfortunately, the developer who wrote this code is no longer employed by the company as we had some concerns over his ability.

The project compiles but the app crashes as soon as it runs. The app loads a JSON feed containing a repeated list of cakes, with title, image and description from a URL, then displays the contents of the feed in a scrollable list.

We would like you to fix the crash bug, ensure the functionality of the app works as expected (all images display correctly on the table, all text is readable) and performs smoothly (ideally, this should be done without third party libraries). You should also refactor, optimise and improve the code where appropriate to use platform best practises.

Please note that we are not looking for perfection, but rather for a clean and pragmatic solution. This should include refactoring but shouldn’t be over engineered. The test can be completed in 2-3 hours; howerever, this is a not a limit. Feel free to spend more time on it if you wish.

## Solution

### Considerations

Firstly, my goal was to identify the bug in the code to get to a functional app. Secondly, I wanted to consider how the data was being loaded and displayed and whether this was actually being done in a way that was correct and scallable. Finally, I wanted to consider the archetecture of the app in terms of what structural design pattern should be used, and look to perform a minimal refactoring of the app to make is conform to a chosen design pattern. Overall, I wanted to ensure that the code was as closely as possible adhering to SOLID design principles, and designed in such a way as to facilitate future unit testing and UI testing.

### Tableview

What I noted initially was that a prototype cell had been created inside of the TableView in the main storyboard. Running the app lead to an error. Debugging this I noticed that the identifier defined in the storyboard did not match the code so this was corrected.

The next thing to do was to separate out the tableview cell which allows us to flexibly reuse the cell in other tableviews should we wish to.

A common challenge with tableview cells is arround cell re-use (being a mechanism tableviews use for efficiency) and we want to make sure that this is correctly handled. This can particularly be an issue where the data we want to show is not imediately avaliable, such as when we load it from a network.

We load images into our cells using asychronous network fetching, but we also need to make sure that when the asychrnous fetch completes, and the image is placed, this does not end up in the wrong place due to cell re-use.

One really good (possibly the best way) to do this is using a really good library called SDWebImage: This handles the caching of images, and prioritising of fetching tasks for images for cells which are still on screen.

Since the instructions suggest avoiding third party libraries, we can use simpler methods to ensure that the cell we're placing the image into will be the correct one. We can also define our own custom cache, or we can use the build in cache in  the likes NSURLSession (which we can also customise the settings for, such as the size of this build in cache).