Apipie.configure do |config|
  config.app_name                = "Apirest"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apidocs"
  config.translate               = false
  config.validate                = false
  config.default_version         = "v1"
  config.show_all_examples       = true
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
