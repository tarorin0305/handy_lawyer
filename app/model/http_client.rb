require 'faraday'
class HttpClient
  VERSION = 1

  def initialize(law_num)
    @law_num = URI.encode(law_num)
  end

  def get(article)
    response = Faraday.get "https://elaws.e-gov.go.jp/api/#{VERSION}/articles;lawNum=#{@law_num};article=#{article}"
  end
end