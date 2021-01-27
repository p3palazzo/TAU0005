source "https://rubygems.org"
# Downgrade Jekyll from 4.1.0 to 3.8.5, Jekyll-feed from 0.12 to 0.11,
# remove gem "sassc" and gem "stringex" if using gem "github-pages"
# See https://stackoverflow.com/questions/58598084/how-does-one-downgrade-jekyll-to-work-with-github-pages
gem "jekyll", "~> 4.2"
gem "tufte-pandoc-jekyll"
gem "webrick" #required by ruby 3.0
#gem "github-pages", group: :jekyll_plugins
group :jekyll_plugins do
  gem "jekyll-feed"#, "~> 0.11"
  gem "jekyll-pandoc"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
  # Required GitHub Pages plugins below
  gem "jekyll-coffeescript"
  gem "jekyll-optional-front-matter"
  gem "jekyll-paginate"
  gem "jekyll-readme-index"
  gem "jekyll-relative-links"
  # Gems incompatible with GitHub Pages
  #gem "jekyll-scholar"
  # Gems required by Jekyll 4
  gem "stringex"
  # Sassc is preferred to the legacy ruby-sass
  gem "sassc"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?

