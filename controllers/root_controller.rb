class RootController < BaseController
  def initialize(params)
    @params = params
  end

  def generate_response_body
    return { data: {
      article: '指定なし',
      content: 'no content'
    } }.to_json
  end
end