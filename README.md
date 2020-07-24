# flutter_dev_connector

A Flutter version of the dev_connector client developed in [MERN Stack Front To Back: Full Stack React, Redux & Node.js](https://www.udemy.com/course/mern-stack-front-to-back/ "Udemy Course")


## To Do

* Improve Routes for Web URLs
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
  * POST posts
  * GET posts/:postId
  * DELETE posts/:postId
  * POST post/like/:postId
  * POST post/unlike/:postId
  * POST posts/comment/:postId
  * DELETE posts/comment/:postId/:commentId
  * 

## Development Getting Started

In order to generate JSON serializers:

    flutter pub run build_runner build

## Running

Requires server defined by BASE_URL=http://192.168.1.159:5000.

