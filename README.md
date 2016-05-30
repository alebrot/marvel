# marvel

## App Description

Using this application, users will be able to browse through the Marvel library of characters. The
data is available by connecting to the Marvel API (http://developer.marvel.com/).

### List of Characters
In this view, a list of characters loaded from the Marvel API character index is presented.
When reaching the end of the list, if there are additional results to show, they should be loaded.

### Filter Results
When tapping on the magnifier icon, characters can be searched by name.

### Character Details
When selecting a character, a detail view of that character is presented. Most of this
information is already available on the result of the first API call, except for the images to be
presented on the comics/series/stories/events sections. Those images can be fetched from the
resourceURI and are lazy loaded. That same behaviour is expected when expanding
those images.

## Screenshots:

* List of Characters Screen
* Character Description Screen
* Search Characters Screen
* Comics Gallery Screen

![List of Characters Screen](/marvel-list-index.png?raw=true "List of Characters Screen")
![Character Description Screen](/marvel-description.png?raw=true "Character Description Screen")
![Search Characters Screen](/marvel-search.png?raw=true "Search Characters Screen")
![Comics Gallery Screen](/marvel-gallery.png?raw=true "Comics Gallery Screen")



