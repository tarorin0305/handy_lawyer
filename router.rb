# 各controller を require
Dir[File.expand_path('../app/controllers', __FILE__) << '/*.rb'].each do |file|
  require file
end
class Router
  def self.detect_controller(path:, params:) # { article: 1 }
    case path
    when '/api/v0/corporate_law'
      ::CorporateLawController.new(params)
    when '/api/v0/civil_law'
      ::CivilLawController.new(params)
    else
      ::RootController.new(params)
    end
  end
end