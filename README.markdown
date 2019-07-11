# blog.panter.ch

## Install
```
bundle install
```

## Create a new article 
Create new articles in git branches `git checkout -b articles/dd-mm-yyyy` called `articles/xx-yy-zz`. 
You can then start a review process by submitting a PR on github if needed.

The following will create a boilerplace article with a properly named file
and some meta-data in `sources`:
```
bundle exec middleman article "INSERT TITLE"
```

See a preview by running
```
bundle exec middleman server
```

## Build and publish
Your key needs to be added to the Server by an Admin.

```
bundle exec middleman build  # Compile all files into the build directory
bundle exec middleman deploy  # Build and publish to Github Pages
```
