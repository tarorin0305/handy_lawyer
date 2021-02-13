require_relative './parser/article_parser'
require_relative './parser/paragraph_parser'

class CivilLaw
  def initialize(article_num)
    @article_parser = ArticleParser.new(law_num, article_num)
  end

  def law_num
    '明治二十九年法律第八十九号'
  end

  def parse_like_real_roppo_to_stdout(article)
    @article_parser.parse_like_real_roppo_to_stdout(article)
  end

  def fetch_article
    @article_parser.parse_article
  end
end
