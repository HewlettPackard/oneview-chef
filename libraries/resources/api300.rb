module OneviewCookbook
  # Module for Oneview API 300 Resources
  module API300
  end
end

# Load all API-specific resources:
Dir[File.dirname(__FILE__) + '/api300/*.rb'].each { |file| require file }
