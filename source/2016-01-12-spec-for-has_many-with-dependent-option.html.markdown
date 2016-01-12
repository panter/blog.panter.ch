---
title: Spec for has_many with dependent option
date: 2016-01-12 14:43 UTC
author: lex
tags:
---

Every rails app almost certainly contains one or more `has_many` associations.
Omitting the `dependent` option means that on deletion the foreign key gets
nullified. In many cases this is not the expected behaviour though. Even if it
is, it makes sense that we think about the behaviour of the relation for each
`has_many` definition. Not thinking about how the associated objects behave on
deletion often results in orphaned database entries and even in inconsistent
data.

Adding a simple test to the spec suite asserts that every `has_many`
association has explicitly defined the `dependent` option.

First, we need two simple helper methods to get all our models and their
`has_many` associations.

<script src="https://gist.github.com/koffeinfrei/7834fce1a5b7b995b412.js?file=active_record_helper.rb"></script>

Then we should require these helper methods and expose them to our specs.

<script src="https://gist.github.com/koffeinfrei/7834fce1a5b7b995b412.js?file=rails_helper.rb"></script>

And finally, let's add the spec that creates an example for each model.

<script src="https://gist.github.com/koffeinfrei/7834fce1a5b7b995b412.js?file=active_record_base_spec.rb"></script>

The output could look something like the following in case we forget to define
the option on one of the relations.

<script src="https://gist.github.com/koffeinfrei/7834fce1a5b7b995b412.js?file=output"></script>

Now, every time we add a new model to our rails app and forget to define the
`dependent` option we get a failing spec.
