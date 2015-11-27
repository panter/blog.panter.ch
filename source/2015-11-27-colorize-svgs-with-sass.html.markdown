---
title: Colorize SVGs with SASS
date: 2015-11-27 16:05 UTC
author: bro
tags: 
---

As you might know it is possible to style an SVG image via CSS if you
inline it. The problem, though, is that you cannot do this when the SVG
image is used as a background image in CSS.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400">
  <circle cx="100" cy="100" r="50" stroke="black" stroke-width="5" fill="none" />
</svg>
```

```css
.circle {
  background-image url(circle.svg);
}
```

You can use [CSS masks](http://www.w3.org/TR/css-masking/), [but not all
browsers support it](http://caniuse.com/#feat=css-masks).

```css
.circle {
  background-color: blue;
  mask-image: url(circle.svg);
}
```

Alternatively, if you use SASS in your Rails application already, you can write your own
SASS function to inline the SVG. As an example you can change the color of all strokes (script
[inspired by this Compass issue] (https://github.com/Compass/compass/issues/1460#issuecomment-65132746)
:

```ruby
require 'sass'
require 'cgi'

module Sass::Script::Functions
  def colorize_svg_strokes(svg_name, color)
    raise "Not a valid color: #{color}" unless color.is_a?(Sass::Script::Color)

    asset = Rails.application.assets.find_asset(svg_name.value)
    raise "File not found: #{svg_name}" unless asset

    svg = File.read(asset.pathname)

    change_color!(svg, color)
    
    encoded_svg = CGI::escape(svg).gsub('+', '%20')
    svg_data = "url('data:image/svg+xml;charset=utf-8," + encoded_svg + "')"
    Sass::Script::String.new(svg_data)
  end

  private

  def change_color!(svg, color)
    svg.gsub!(/stroke=\"([^\"])*\"/, "stroke=\"#{color}\"")
  end
end
```

You have to load that code when your application starts, for example in an
[initializer](https://github.com/exul/colorize-svg/blob/master/config/initializers/sass.rb).

Now you can use the function in your SASS file:

```sass
colorize-svg-strokes('circle.svg', #00FF00)
``` 

Instead of just replacing the color of the stroke you could have placeholders like
`_colorize_` in your SVG and replace them with the given color. But you have to be
careful, because this makes your SVG unusable without the replaced placeholder.

Here's a small Rails application that implements both functions, one to only change
the color of the stroke and the other to replace the placeholder:
[https://github.com/exul/colorize-svg](https://github.com/exul/colorize-svg)
