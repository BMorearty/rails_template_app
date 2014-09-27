# BMorearty make Heroku work. https://devcenter.heroku.com/articles/rails3x-asset-pipeline-cedar
Rails.application.config.assets.initialize_on_precompile = false

# Put each third-party library in its own directory under vendor/assets
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets")

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
