require 'faraday'
require "rexml/document"
require 'active_support/all'
require_relative '../lib/client/http_client'
require 'pry-byebug'

module CorporateLaw
  class Client
    def initialize
      @http_client = HttpClient.new(law_num)
    end

    def law_num
      '平成十七年法律第八十六号'
    end

    def parse_like_real_roppo(article)
      full_result = fetch_article_api(article).dig('DataRoot', 'ApplData', 'LawContents', 'Article')
      output_to_stdout = "#{full_result.fetch('ArticleCaption')} #{full_result.fetch('ArticleTitle')}\n#{parse_paragraph(full_result.fetch('Paragraph'))}"
      puts output_to_stdout
    end

    def parse_paragraph(paragraphs)
      text = ''
      if paragraphs.is_a?(Array)
        paragraphs.each do |paragraph|
          if paragraph.fetch('Num').to_i > 1
            text << "  第#{paragraph.fetch('ParagraphNum')}項 " 
          else
            text << "  "
          end
          text << parse_sentence("#{paragraph.dig('ParagraphSentence', 'Sentence')}")
          if paragraph.dig('Item').present?
            paragraph.dig('Item').each do |item|
              text << "    第#{item.fetch('ItemTitle')}号 #{parse_sentence(item.dig('ItemSentence', 'Sentence'))}"
            end
          end
        end
      else
        text << '  '
        text << parse_sentence(paragraphs.dig('ParagraphSentence', 'Sentence'))
      end

      text
    end

    def parse_sentence(sentence)
      # ただし書きがある場合を考慮
      if sentence.include?("[\"")
        splited_sentence = sentence.gsub(/\[|\]|\"/, '').split(',')
        raise "#{splited_sentence.size}個に分割されたSentenceのパターンが検出されました" if splited_sentence.size > 2
        "#{splited_sentence.first}\n" + "   " + "#{splited_sentence.last}\n"
      else
        sentence + "\n"
      end
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
