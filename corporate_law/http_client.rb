require 'faraday'
require "rexml/document"
require 'active_support/all'
require_relative '../lib/client/http_client'

module CorporateLaw
  class Client
    VERSION = 1

    def initialize
      @http_client = HttpClient.new(law_num)
    end

    def law_num
      '平成十七年法律第八十六号'
    end

    def parse_like_real_roppo(article)
      full_result = fetch_article_api(article).dig('DataRoot', 'ApplData', 'LawContents', 'Article')
      output_to_stdout = "#{full_result.fetch('ArticleCaption')} #{full_result.fetch('ArticleTitle')}\n#{full_result.dig('Paragraph', 'ParagraphSentence', 'Sentence')}"
      puts output_to_stdout
    end

    def fetch_article_api(article)
      response = @http_client.get(article)
      parse_response(response.body)
    end

    def parse_response(response)
      xml = REXML::Document.new(response)
      json = Hash.from_xml(xml.to_s)
    end 
  end
end
