Rails.application.config.assets.paths << Pagy.root.join('javascripts')
require 'pagy/extras/bulma'
Pagy::VARS[:items] = 10
