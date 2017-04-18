###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

activate :blog do |blog|
  blog.layout = "article"
  blog.paginate = true
end

set :page_url, 'https://blog.panter.ch'

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true
set :haml, { ugly: true }

# use syntax highlighting
activate :syntax

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  activate :favicon_maker do |f|
    f.template_dir  = File.join(root, 'source', 'images', 'favicon')
    f.icons = {
      'apple-touch-icon-precomposed.png' => [
        { icon: 'apple-touch-icon-152x152-precomposed.png' },
        { icon: 'favicon.ico', size: '64x64,32x32,24x24,16x16' },
      ]
    }
  end

  activate :imageoptim, :pngout => false, :svgo => false

  activate :gzip
end

activate :deploy do |deploy|
  deploy.method = :rsync
  deploy.host = 'blog.panter.ch'
  deploy.user = 'panterch'
  deploy.clean = true

  deploy.path = 'blog.panter.ch'

  deploy.flags = '-avz'
end

configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
helpers do
  def article_author(article)
    data.authors[article.data.author]['name']
  end
end
