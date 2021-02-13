require 'faraday'
require "rexml/document"
require 'active_support/all'
require_relative './paragraph_parser'
require_relative '../http_client'


class ArticleParser # 細かな整形はせず、条文(=Article)のJSONを生成するだけにする。
  def initialize(law_num, article_num)
    @http_client = HttpClient.new(law_num)
    @article_num = article_num
  end

  def parse_like_real_roppo_to_stdout
    output_to_stdout = parse_article
    puts output_to_stdout
  end

  def parse_article # ここに取得したオブジェクトの整形処理を書かないようにする
    full_result = fetch_article_api.dig('DataRoot', 'ApplData', 'LawContents', 'Article')
    full_result
    # "#{full_result.fetch('ArticleCaption', nil)} #{full_result.fetch('ArticleTitle')}\n#{parse_paragraph(full_result.fetch('Paragraph'))}"
  end

  # NOTE: Presenter層に移譲した
  # def parse_paragraph(paragraphs)
  #   text = ''
  #   if paragraphs.is_a?(Array)
  #     paragraphs.each do |paragraph|
  #       parser = ParagraphParser.new(paragraph)
  #       text << parser.output_parsed_sentence
  #     end
  #   else
  #     text << '  '
  #     text << ParagraphParser.new(paragraphs).parse_sentence(paragraphs.dig('ParagraphSentence', 'Sentence'))
  #   end

  #   text
  # end

  def fetch_article_api
    response = @http_client.get(@article_num)
    response_to_h(response.body)
  end

  def response_to_h(response)
    xml = REXML::Document.new(response)
    Hash.from_xml(xml.to_s)
  end 
end
