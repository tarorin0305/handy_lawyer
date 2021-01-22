require_relative './parser/article_parser'
require_relative './parser/paragraph_parser'
require 'pry-byebug'

class CorporateLaw
  def initialize
    @article_parser = ArticleParser.new(law_num)
  end

  def law_num
    '平成十七年法律第八十六号'
  end

  def parse_like_real_roppo_to_stdout(article)
    @article_parser.parse_like_real_roppo_to_stdout(article)
    yield if block_given?
  end

  def parse_like_real_roppo(article)
    @article_parser.parse_like_real_roppo(article)
  end
end
