---
title: Meteor and THREE.js
date: 2015-11-10 21:30
tags:
---

We at Panter already combined Meteor with a 2D canvas libraries ([Konva / Kinetic.js](https://github.com/konvajs/konva)), so 3D rendering is the next logical step.

Meteor is a "fullstack" webframework, covering both client and server. If you haven't heard about it, check it out at [meteor.com](https://www.meteor.com/).

Meteor updates its views as soon as the underlying data changes in a reactive way. The default rendering engine *Blaze* and the template language *spacebars* provide an easy way to work with html, but what if we want to use other renderers such as THREE.js and update a 3D view in a reactive way?

## Preparations

In this example the meteor-smartpackage 'limemakers:three', but you can add the THREE.js-files also manually.

## Set the scene

Let's start by defining a first template and attach data (a cursor) to it:

~~~

<template name="app">
  <h1>my first 3d-App</h1>
  {{>THREE_scene objects=players width="100%" height="500px"}}
</template>

Template.app.helpers
  players: -> Collections.Players.find()

~~~

The *THREE_scene*-template defines a container which is later used by THREE.js to render the scene:

~~~

<template name="THREE_scene">
  <div class="container" style="width: {{width}};height:{{height}}">
  </div>
</template>

Template.THREE_scene.onRendered ->
  # init renderer and scene
  renderer = new THREE.WebGLRenderer antialias: true
  renderer.setPixelRatio window.devicePixelRatio
  renderer.setSize @$(".container").width(), @$(".container").height()
  @$(".container").append renderer.domElement
  scene = new THREE.Scene()

  (...)

~~~

## Setup the camera

Let's add a camera and make it rotatable with the mouse and let there be light:

~~~

Template.THREE_scene.onRendered ->

  (...)

  # init camera
  camera = new THREE.PerspectiveCamera 75,
    (@$(".container").width() / @$(".container").height()), 0.1, 1000
  camera.position.z = 5
  controls = new THREE.OrbitControls camera, renderer.domElement

  # let there be light
  scene.add new THREE.AmbientLight 0x505050
  light = new THREE.SpotLight 0xffffff, 1.5
  light.position.set 0, 500, 2000
  light.castShadow = true
  scene.add light

  (...)

~~~

## Start the rendering loop

While the template is rendered, we can use `requestAnimationFrame` to re-render the scene. If we change any objects added to the scene, THREE.js will update all these objects.

NB: we are still in the `Template.THREE_scene.onRendered`-callback. We can check if this template has been destroyed, by checking the `isDestroyed`-property on the underlying Blaze-view.

~~~

## Start render-loop

Template.THREE_scene.onRendered ->

  (...)

  render = =>
    unless @view.isDestroyed
      requestAnimationFrame render
      renderer.render scene, camera
  render()

  (...)

~~~

## Enter `cursor.observe`

Meteor's `cursor.observe` and `cursor.observeChanges` allows to observe a Meteor collection on added, changed or removed documents. This allows us to couple the collection with the *THREE.js*-Scene.

To map document-id's to THREE.js-Objects, we create a simple object that holds all references to THREE.js objects placed to the view (There are other approaches for this like finding elements on the scene by name).

The general pattern for this looks like this:

~~~

### start observation

Template.THREE_scene.onRendered ->

  (...)

  # this object will hold references to all THREE.js-objects
  sceneObjects = {}

  observeHandle = @data.objects?.observeChanges
    added: (id, fields) ->
      (...)
      sceneObjects[id] = threejsObject
      (...)

    changed: (id, fields) ->
      # update sceneObjects[id] ....
      (...)

    removed: (id) ->
      obj = sceneObjects[id]
      scene.remove obj
      delete sceneObjects[id]

  (...)

~~~

### In detail: the `added`-callback

We create simple cube in this example, but you could also call a constructor dynamically. E.g. you could add a `type`-property to every document and call a matching constructor.

After creation we add the object to the scene and store a reference to this object. We also receive a `fields`-parameter in this callback which holds all properties of the document. We can simply copy these properties onto the THREE-js object with `deepSet`, so that it reflects the state on the database. The function `deepSet` is explained below.

~~~

Template.THREE_scene.onRendered ->

  (...)

  observeHandle = @data.objects?.observeChanges
    added: (id, fields) ->
      geometry = new THREE.BoxGeometry 1, 1, 1
      material = new THREE.MeshLambertMaterial
      obj = new THREE.Mesh geometry, material
      scene.add obj
      # store reference to this object
      sceneObjects[id] = obj
      deepSet sceneObjects[id], fields

deepSet = (obj, properties) ->
  for key, value of properties
    if _.isObject value
      deepSet obj[key], value
    else
      obj[key] = value

~~~

### In detail: the `changed-callback

The `changed`-callback will notify us about documents that have been changed in the database. We simply copy the changed properties onto the THREE.js-object (again with `deepSet`).

~~~

    changed: (id, fields) ->
      # find the referenced object and update all its properties
      deepSet sceneObjects[id], fields

~~~

### Tidy up

`cursor.observeChanges` returns a handle that we have stored in the `observeHandle` variable. We use this to stop the observation once the template has been destroyed:

~~~

Template.THREE_scene.onRendered ->

  (...)

  @view.onViewDestroyed ->
    observeHandle?.stop()

~~~

## Play with it

The THREE_scene-template now reflects every object in the Players-collection. Start the app, open the console and type:

`Collections.Players.insert({})`

This will insert a white cube into the scene. We can now move this cube around:

`Collections.Players.update("wJ4XAkA4MCCk9A3oy", {$set:{position:{x:-2,y:2, z:0.5}}})`

Or we can rotate it:

`Collections.Players.update("wJ4XAkA4MCCk9A3oy", {$set:{rotation:{x:10,y:5, z:12}}})`

We can even change the color of the cube:

`Collections.Players.update("wJ4XAkA4MCCk9A3oy", {$set:{material:{color:{r:0.8,g:0.2, b:0.3}}}})`

If you open another browser window, you will see that these changes are reflected immediately on all clients. But since you know meteor, that's what you'd expect, isn't it?


Source-code: [github.com/panter/meteor-threejs-demo](https://github.com/panter/meteor-threejs-demo)

Demo: [panter-threejs-demo.meteor.com](http://panter-threejs-demo.meteor.com/)

![Screenshot](images/2015-09-08-meteor-and-three-js/screenshot.png)


