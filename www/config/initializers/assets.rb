# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

Rails.application.config.assets.precompile += %w( sweetalert.css sweetalert.min.js )
Rails.application.config.assets.precompile += %w( bootstrap-tour.min.css bootstrap-tour.min.js )
Rails.application.config.assets.precompile += %w( bootstrap-sortable.css bootstrap-sortable.js )
Rails.application.config.assets.precompile += %w( moment.min.js tinysort.js typeahead.js )
Rails.application.config.assets.precompile += %w( search_results.css )
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
Rails.application.config.assets.precompile += %w( jqcloud.js jqcloud.css )