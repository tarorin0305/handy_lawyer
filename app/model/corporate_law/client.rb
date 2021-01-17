require 'faraday'
require "rexml/document"
require 'active_support/all'
require_relative '../http_client'
require_relative '../paragraph_parser'
require 'pry-byebug'

module CorporateLaw
  class Client
    def initialize
      @http_client = HttpClient.new(law_num)
    end

    def law_num
      '平成十七年法律第八十六号'
    end

    def parse_like_real_roppo_to_stdout(article)
      full_result = fetch_article_api(article).dig('DataRoot', 'ApplData', 'LawContents', 'Article')
      output_to_stdout = "#{full_result.fetch('ArticleCaption')} #{full_result.fetch('ArticleTitle')}\n#{parse_paragraph(full_result.fetch('Paragraph'))}"
      puts output_to_stdout
    end

    def parse_like_real_roppo_to_json(article)
      full_result = fetch_article_api(article).dig('DataRoot', 'ApplData', 'LawContents', 'Article')
      output = "#{full_result.fetch('ArticleCaption')} #{full_result.fetch('ArticleTitle')}\n#{parse_paragraph(full_result.fetch('Paragraph'))}"
      output
    end

    def parse_paragraph(paragraphs)
      text = ''
      if paragraphs.is_a?(Array)
        paragraphs.each do |paragraph|
          parser = ParagraphParser.new(paragraph)
          text << parser.output_parsed_sentence
        end
      else
        text << '  '
        text << ParagraphParser.new(paragraphs).parse_sentence(paragraphs.dig('ParagraphSentence', 'Sentence'))
      end

      text
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
