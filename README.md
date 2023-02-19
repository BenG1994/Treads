# Treads

Treads is an app that allows the user to tracks their runs and see the distance, pace, runtime, and path of their previous runs.

## Introduction

Treads is from a tutorial by Devslopes with the focus on working with MapKit, Realm, and saving user input data.

## Skills used

* MapKit (center location, create polyline from saved coordinates, zoom in on user location, coordinate regions)
* Saved data with Realm and Realm configurations
* Tableviews, tableview cells
* Create custom slider to end run
* Counters for pace, distance, and duration
* Type extensions to format date, distance, and duration
* Tab bar controller

## Process and challenges

Setting up the UI for Treads was simple and where everything started. After adding a tab bar controller, it was a simple as adding a MapView and several buttons on the main view controller, a tableview, cells, and labels on another, and more labels for the counters when in a run. The most difficult part of the UI was creating a custom slider to end the run. After adding the UI elements to make up the design of the button, I was able to get it slide using a Pan Gesture Recognizer and adding its translation of how far it can slide. Once it reached its max point to the left, all I needed to do was call a function that ended the run and dismissed the view controller.

![Simulator Screen Recording - iPhone 14 Pro - 2023-02-18 at 21 29 57](https://user-images.githubusercontent.com/113778995/219912766-59c255e8-5396-49d2-b903-0bbe74f40934.gif)

To properly format the counters for duration, pace, and distance, I created extensions for each type. That allowed me to quickly format distance to kilometers, time to either minutes and seconds, or include hours in certain places. It also let me reorder the date into whatever format I wanted.

Once a run is finished, displayed the last run on the MapView along with the data from that run. I set up a function that centered around the last run based on the coordinates saved and giving it padding so you can see the entire run. Adding a polyline on top of the run coordinates allows users to properly see the path they took. Users runs will also appear immedaitely in the tableivew of logs with all the saved data from each run, organized by most recent run on top.

![Simulator Screen Recording - iPhone 14 Pro - 2023-02-18 at 21 16 31](https://user-images.githubusercontent.com/113778995/219914016-d4c56165-ef60-48a4-95cb-37f6c14ec8c9.gif)

To save user data, I used Realm for this app. Creating a Realm database is simple and straightforward. Thankfully, all the data needed to be saved with Treads were compatible with Realm; in this case it was pace (int), distance (double), duration (int), date (NSDate), and location (CLLocations, which are doubles). However, locations were added after the Realm database was created, so I added a Realm configuration to add that data in without having to reset the database.

And if you close the final run tab that appears after your last run or when you launch the app, it'll center on your current location instead of around the run path.

![Simulator Screen Recording - iPhone 14 Pro - 2023-02-18 at 21 45 43](https://user-images.githubusercontent.com/113778995/219916619-aab4cb23-fce6-4938-88af-215570412a70.gif)

## Reflection

While Treads used many common and straightfoward elements of iOS development, I enjoyed the process as it allowed me more experience with Realm to save user data, as well as MapKit. But it taught me a few extra elements with both of those, such as Realm configurations and adding polylines and region coordinates with MapKit. It was a fun project that I can see using many skills on in future projects.






