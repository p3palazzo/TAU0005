source "https://rubygems.org"
gem "jekyll", "~> 4.1"
gem "minima"
#gem "minima-scholar", "~> 2.5.3"
#gem "github-pages", group: :jekyll_plugins
group :jekyll_plugins do
  gem "jekyll-feed"#, "~> 0.11"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"
  # Sassc is preferred to the legacy ruby-sass
  gem "sassc"
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
end
# Jekyll-feed had to be downgraded from 0.12 to 0.11 due to compatibility
# with github-pages (which presently does not support jekyll 4.0).
# See https://stackoverflow.com/questions/58598084/how-does-one-downgrade-jekyll-to-work-with-github-pages

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?

