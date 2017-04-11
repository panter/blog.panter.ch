---
title: Meteor WIP
date: 2017-04-06 14:49 UTC
tags:
---

# Putting Meteor to work
We're always keen about new technologies and outside of our work we're constantly playing around with all the fancy new .js stuff.
In this Javascript world there are so many Frameworks and Libraries entering our Ecosystem every day and most of them end up as a shooting star, only leaving debris on our laptops hardware. Putting it with the words of my teacher from back of 2015 "Javascript will always end up producing prototypes and unfinished work", we call Bullshit.
In this Blogpost we want to show you how we're putting Meteor to work.

## Hosting your Meteor application on your *own* servers
Just recently i read a interesting Post from a German Scientist in the Meteor forums, he was ranting about how he wants to deploy his *own* applications on his *own* bare metal and how he dislikes all the cloud solutions. We agree.

So let's setup our server in order to put our App(s) to production, in this example we'll be using a single host to deliver a single application. We'll be using a fresh install of Debian GNU/Linux 8 (Jessie) we won't get into details regarding hardening your Servers or how to configure X and Y, you'll need at least some basic skills to follow through (But in regards that you want to host an application on your own bare metal we assume you do).

### Prerequisites
* Bare Metal Server
* [Debian 8 Jessie](https://www.debian.org/devel/debian-installer/)
* [NGINX](https://www.nginx.com)
* [Phusion Passenger](https://www.phusionpassenger.com/)
* [Forever](https://github.com/foreverjs/forever)
* Some cups of coffee

