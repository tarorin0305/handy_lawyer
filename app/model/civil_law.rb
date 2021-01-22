require_relative './parser/article_parser'
require_relative './parser/paragraph_parser'
require 'pry-byebug'

class CivilLaw
  def initialize
    @article_parser = ArticleParser.new(law_num)
  end

  def law_num
    '明治二十九年法律第八十九号'
  end

  def parse_like_real_roppo_to_stdout(article)
    @article_parser.parse_like_real_roppo_to_stdout(article)
  end

  def parse_like_real_roppo(article)
    @article_parser.parse_like_real_roppo(article)
  end
end
