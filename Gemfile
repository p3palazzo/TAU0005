source "https://rubygems.org"
gem "jekyll", "~> 4.2"
gem "minimal-mistakes-jekyll", "~> 4.24"
gem "bibtex-ruby"
gem "sassc"
gem "stringex"
gem "webrick" #required by ruby 3.0
group :jekyll_plugins do
  gem "jekyll-data"
  gem "jekyll-feed"
  gem "jekyll-gist"
  gem "jekyll-include-cache"
  #gem "jekyll-paginate"
  gem "jekyll-pandoc"
  gem "jekyll-relative-links"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?

