# flutter_dev_connector

A Flutter version of the dev_connector client developed in [MERN Stack Front To Back: Full Stack React, Redux & Node.js](https://www.udemy.com/course/mern-stack-front-to-back/ "Udemy Course")


## To Do

* Tidy Up
  * Logging
  * Sort out Provider vs ChangeNotifierProvider
  * Sort out Theme to avoid repeated fontSize and color values
* Add Authentication
  * /register
  * /login
  * Save Webtoken
  * Authenticated Routes
* Improve Routes
* Dashboard
  * /dashboard
  * /create-profile
  * /edit-profile
  * /add-experience
  * /add-education
* Posts
  * /posts
  * /posts/:id
* Responsive UI
  * Mobile, Tablet, Desktop
  * Web features
* Stacked Architecture

## Done

* Profile
  * /profiles
  * /profile/:id

## Development Getting Started

In order to generate JSON serializers:

    flutter pub run build_runner build

## Running

Requires server on http://localhost:5000.


