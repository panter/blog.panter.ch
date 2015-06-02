# blog.panter.ch

## Install
```
bundle install
```

## Create a new article
```
# Creates a new article in the format {year}-{month}-{day}-{title}.html
middleman article "INSERT TITLE"
```

## Build and publish
```
rake build    # Compile all files into the build directory
rake publish  # Build and publish to Github Pages
```
