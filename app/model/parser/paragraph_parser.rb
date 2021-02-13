# NOTE: Presenter層に移譲した

# require 'pry-byebug'
# require 'active_support/all'
# # 会社法第107, 238条で動作検証済み
# class ParagraphParser
#   attr_reader :paragraph
#   def initialize(paragraph)
#     @paragraph = paragraph
#     @text = ''
#   end

#   def output_parsed_sentence
#     # 項のパース
#     parse_paragraph_sentence

#     # 号以降のパース
#     if with_items? # 号を持つ場合
#       parse_sentence_with_items
#     else
#       @text
#     end
#   end

#   def parse_paragraph_sentence
#     @text << add_indent(1)
#     @text << "第#{paragraph.fetch('ParagraphNum')}項 " if paragraph.fetch('ParagraphNum').present?
#     @text << parse_sentence(paragraph.dig('ParagraphSentence', 'Sentence'))

#     return @text
#   end

#   def parse_sentence_with_items
#     paragraph.dig('Item').each do |item|
#       # イロハがあるかチェック

#       if with_subitems?(item)
#         # 号番号と号本文を取得
#         @text << add_indent(2)
#         item_title = item.fetch('ItemTitle')
#         @text << "第#{item_title}号 "
#         item_sentences = item.dig('ItemSentence', 'Column')
#         item_sentences.each do |item_sentence|
#           @text << item_sentence.fetch('Sentence')
#           @text << add_indent(1)
#         end
#         # 号配下のイロハの番号とイロハ本文を取得
#         @text << "\n"
#         subitems = item.fetch('Subitem1')
#         subitems.each do |subitem|
#           subitem_title = subitem.fetch('Subitem1Title')
#           subitem_sentence = parse_sentence(subitem.dig('Subitem1Sentence', 'Sentence'))
#           @text << add_indent(3)
#           @text << "#{subitem_title} #{subitem_sentence}"
#         end
#       else
#         @text << add_indent(2)
#         item_title = item.fetch('ItemTitle')
#         item_sentence = parse_item_sentence(item.dig('ItemSentence'))
#         @text << "第#{item_title}号 #{item_sentence}"
#       end
#     end

#     return @text
#   end

#   def with_items?
#     paragraph.dig('Item').present?
#   end

#   def with_subitems?(item)
#     item.dig('Subitem1').present?
#   end

#   def add_indent(n)
#     '  ' * n
#   end

#   def parse_item_sentence(item_sentence)
#     item_columns = item_sentence.fetch('Column', nil).presence
#     if item_columns.present?  # 「〜の場合 〜の事項」という列挙タイプの条文
#       text = ''
#       item_columns.each do |item_sentence|
#         text << add_indent(3) if item_sentence.fetch('Num').to_i > 1 # 「〜の事項」の部分をインデントする
#         text << item_sentence.fetch('Sentence') + "\n"
#       end
#       return text
#     else
#       parse_sentence(item_sentence.fetch('Sentence'))
#     end
#   end

#   def parse_sentence(sentence)
#     # ただし書きがある場合を考慮
#     if sentence.is_a?(Array)
#       raise "#{sentence.size}個に分割されたSentenceのパターンが検出されました" if sentence.size > 2
#       "#{sentence.first}\n" + "   " + "#{sentence.last}\n"
#     else
#       sentence + "\n"
#     end
#   end
# end
