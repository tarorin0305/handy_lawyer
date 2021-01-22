class CorporateLawController < BaseController
  def initialize(params)
    @params = params
  end

  def generate_response_body
    article = article_params(@params).to_i
    return { error: '条文番号には1以上の整数を指定してください' }.to_json if article < 1

    content = ::CorporateLaw.new.parse_like_real_roppo(article)
    result = { 
      data: {
        article: article,
        content: content
      },
      debugg: {
        params: @params
      }
    }

    result.to_json
  end

  def article_params(params)
    params.select { |key| key == 'article' }.fetch('article', nil)
  end
end