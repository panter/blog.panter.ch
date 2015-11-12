---
title: Idempotent seeds in rails
date: 2015-08-05 21:11 UTC
author: Alexis Reigel
tags:
---

Database seeds are a very handy tool in rails.
They ease setting up a proper development environment with meaningful data.
One issue with the out of the box seeds is though that they are not
[idempotent](https://en.wikipedia.org/wiki/Idempotence) per se.
While developing an application you don't want to always reset the database
to get a proper seed state. If the seeds were idempotent,
you could run `rake db:seed` as many time as you'd like without
corrupting the integrity of your data. Just as migrations,
running the seeds should only update your database if necessary.

A simple helper method helps creating idempotent data easily.

<script src="https://gist.github.com/koffeinfrei/04bbe38f16ff9d49bebd.js?file=db.rake"></script>

* The first argument `model` is the model class
* The second argument `find_or_create_by` is a hash of attributes that are used
  for finding a record. If the record doesn't exist, it will be created.
  This hash is like the unique identifier of a seed record.
* The third argument `update_with` is a hash of attributes that will be always
  set on the record, whether the record already exists or has to be created.
  This is useful when the seeds are extended and you want to
  update existing records with new attributes.

The actual seed could look something like this.

<script src="https://gist.github.com/koffeinfrei/04bbe38f16ff9d49bebd.js?file=seeds.rb"></script>

That's it. Now execute `rake db:seed` a few times to get back your confidence in your seeds.
