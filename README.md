# yetanotherimagegallery

Image gallery that uses public image flickr feed (https://www.flickr.com/services/feeds/docs/photos_public)
Ability to sort by date published/taken and filter images based on tags as well as previewing image details.
Ability to share photo, open it as link in browser and save to camera roll.
It uses MVP + Coordinators architectire with dependency injection patter.
Storyboards are non-existent - replaced with code based constraints (using SnapKit).
Calls to api are made with Alamofire. Image caching made with Kingfisher.
It contains all needed dependencies and was build with Xcode 8.3.3 and Swift 3.1.1.

Project overview:
- uses carthage as dependency manager
- uses Swinject as preferred framework for dependency injection
- uses code-based views with SnapKit as constraint framework
- uses Alamofire to simplify networking
- uses Kingfisher to simplify image caching
- uses Quick/Nimble for faster/simpler unit testing

Instructions:
- open project dir
- `carthage bootstrap --platform ios`
- open .xcproject

