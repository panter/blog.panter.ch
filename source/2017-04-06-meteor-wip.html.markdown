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
* Knowledge that this is your Server and you should _never_ copy & paste a tutorial

I could tell some wonderful stories about how you could bring your server to your Datacenter and how to configure your Network, but we'll do it the quick and painless way and start right away after your fresh install of Debian (don't forget to update & upgrade your packages)

We'll need a Webserver (NGINX) a Node Package Manager (NPM) and a Database (MongoDB) to setup a basic server which is able to serve a Meteor application, for better performance we'll tweak the setup after our basic setup.

But first we'll get Problems out of our way by installing/updating HTTPS Apt Sources and our trusted certs
```
apt-get install apt-transport-https ca-certificates
```

We'll need to add the source for NodeJS to our sources.list (/etc/apt/sources.list.d/nodesource.list), feel free to adjust the Node version if needed.
```
# nodesource
deb https://deb.nodesource.com/node_4.x jessie main
```
> Github Repo:https://github.com/nodesource/distributions

Now that we added our Sources we'll need to install our required packages
```
apt-get install apt-mongodb-org nginx nodejs npm
```

We'll need to add some sources to our sources.list in order to get our desired Passenger packages.
```
# Install Phusion Passengers PGP key and add HTTPS support for APT
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7

# Add Phusion Passengers APT repository
sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger jessie main > /etc/apt/sources.list.d/passenger.list'
apt-get update
```
> Source: https://www.phusionpassenger.com/library/install/nginx/install/oss/jessie/
