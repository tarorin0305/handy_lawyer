require 'faraday'
require "rexml/document"
require 'active_support/all'
require_relative './paragraph_parser'
require_relative '../http_client'
require 'pry-byebug'


class ArticleParser
  def initialize(law_num)
    @http_client = HttpClient.new(law_num)
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
