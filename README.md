# Task App
This is a basic todo app for an AAG assignment.
The design is geared toward portait use.

Let me know if you need any help setting up your Flutter environment!

## Functionality
I've decided to go with implementing all the functionality with the addition of editing. 

Editing is accomplished by tapping a title or description; the optional description can also be added later, which you can see by expanding a task that was created with none.

Tasks are dismissable, so just swipe to delete.

The app has persistence and filtering

## Structure
We have models, state, and UI directories.

Given more complexity, we introduce a Services folder to keep logic and data/api access apart from our notifiers, as well as subfolders for them all in order to organize based on feature and data access.

Another approach is to organize based on feature and/or model with the pertaining UI, state, etc. files collated.

#### Models
Models are rather self-explanatory dart files for objects that possess our state and so forth. We can keep our enums in there as well. Especially when subfolders arise, this is convenient and clean.

#### State
The state folder essentially contains notifiers.
The provider for accessing a given notifier is conveniently declared in the same file.

#### UI
UI files name preferably end with a noun of what type of UI element they are.  For example, a screen is generally a widget that possesses a Scaffold which will contain other widgets displayed on the screen; thus file name end for such widgets should be '_screen.dart'

## State Management
This app uses Flutter Riverpod for state management without hooks or code generation.
Riverpod utilizes notifiers and providers which together inform widgets of state changes and thus whether they need to rebuild.

## Persistence
 Riverpod 3 released Wednesday, 9/10 introduced persistence, which is actually a perfect solution for this need. It is being called experimental for now, so it's perfect for a sample like this or a poc.


##### Additional notes

- Enhanced enum is used for task filter to demonstrate a use case, though it is a bit redundant here.
- The next thing I would add is character limits for title and description based on business requirements.
- Following, I would optimize UI for landscape (for web/tablet).