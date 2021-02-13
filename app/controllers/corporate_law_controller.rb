class CorporateLawController < BaseController
  def initialize(params)
    @params = params
  end

  def generate_response_body # webAPIとしてJSONを返すためのアクション
    article_num = article_params(@params).to_i
    return { error: '条文番号には1以上の整数を指定してください' }.to_json if article_num < 1
    
    raw_article = CorporateLaw.new(article_num).fetch_article
    article_content = ::ArticlePresenter.new(raw_article).to_json
    result = { 
      data: {
        article: article_num,
        content: article_content
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