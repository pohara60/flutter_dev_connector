# flutter_dev_connector

A Flutter version of the dev_connector client developed in [MERN Stack Front To Back: Full Stack React, Redux & Node.js](https://www.udemy.com/course/mern-stack-front-to-back/ "Udemy Course")


## To Do

* Tidy Up
  * 
* Add NavBar
  * Improve Routes
* Posts
  * /posts
  * /posts/:id
* Responsive UI
  * Mobile, Tablet, Desktop
  * Web features
* Stacked Architecture

## Server API Done

* Profile
  * GET profiles
  * POST profile
  * DELETE profile
  * GET profile/me
  * GET profile/user/:userId
  * GET profile/github/:username
  * PUT profile/experience
  * PUT profile/education
  * DELETE profile/experience/:id
  * DELETE profile/education/:id
* Posts

## Development Getting Started

In order to generate JSON serializers:

    flutter pub run build_runner build

## Running

Requires server on http://192.168.1.159:5000.

