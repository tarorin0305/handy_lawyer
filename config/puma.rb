require 'pry-byebug' # for debugg
require 'active_support/all'
require_relative '../router'

app do |env|
  path = env['REQUEST_PATH']
  query = URI::parse(env["REQUEST_URI"]).query
  query_array = query.present? ? URI::decode_www_form(query) : []
  controller = Router.detect_controller(path: env['REQUEST_PATH'], params: query_array.to_h)
  body = controller.generate_response_body

  [200, { 'Content-Type' => 'text/plain; charset=UTF-8', 'Content-Length' => body.bytesize.to_s }, [body]]
end