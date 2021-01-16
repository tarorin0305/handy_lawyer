class Router
  def self.detect_controller(path:, params:) # { article: 1 }
    case path
    when '/api/v0/corporate_law'
      ::CorporateLawController.new(params)
    else
      ::RootController.new(params)
    end
  end
end