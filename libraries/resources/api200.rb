module OneviewCookbook
  # Module for Oneview API 200 Resources
  module API200
  end
end

# Load all API-specific resources:
Dir[File.dirname(__FILE__) + '/api200/*.rb'].each { |file| require file }
