class ArticlePresenter
  attr_reader :raw_article
  def initialize(raw_article)
    @raw_article = raw_article
  end

  def to_json
    {
      num: raw_article.fetch('Num').to_i,
      caption: raw_article.fetch('ArticleCaption'),
      paragraphs: paragraphs_to_json
    }
  end

  def paragraphs_to_json
    result = []
    if raw_article.fetch('Paragraph').is_a? (Array)
      paragraphs = raw_article.fetch('Paragraph')
      paragraphs.each do |paragraph|
        result << paragraph_to_json(paragraph)
      end
    else
      result << paragraph_to_json(raw_article.fetch('Paragraph'))
    end

    result
  end

  def paragraph_to_json(paragraph)
    if paragraph.fetch('Item', nil)
      items = items_to_json(paragraph.fetch('Item'))
    else
      items = nil
    end

    {
      num: paragraph.fetch('Num').to_i,
      sentence: (paragraph.fetch('ParagraphSentence')),
      items: items
    }
  end

  def sentence_to_json(sentence)
    if sentence.fetch('Sentence').is_a?(Array)
      honbun = sentence.fetch('Sentence').first
      tadashigaki = sentence.fetch('Sentence').last
    else
      honbun = sentence.fetch('Sentence')
      tadashigaki = ''
    end

    {
      column_num: sentence.fetch('Num', nil).to_i,
      honbun: honbun,
      tadashigaki: tadashigaki
    }
  end

  def items_to_json(items)
    result = []
    items.each do |item|
      result << item_to_json(item)
    end

    result
  end

  def item_to_json(item)
    item_sentences = []
    if item.fetch('ItemSentence').fetch('Column', nil)
      item.fetch('ItemSentence').fetch('Column').each do |item_sentence|
        item_sentences << sentence_to_json(item_sentence)
      end
    else
      item_sentences << sentence_to_json(item.fetch('ItemSentence'))
    end

    sub_items = []
    if item.fetch('Subitem1', nil)
      item.fetch('Subitem1', nil).each do |sub_item|
        sub_items << sub_item1_to_json(sub_item)
      end
    else
      sub_items = nil
    end

    {
      item_num: item.fetch('Num').to_i,
      item_sentences: item_sentences,
      sub_items: sub_items
    }
  end

  def sub_item1_to_json(sub_item1)
    sub_item1_sentences = []
    if sub_item1.fetch('Subitem1Sentence').fetch('Column', nil)
      sub_item1.fetch('Subitem1Sentence').fetch('Column').each do |sub_item1_sentence|
        sub_item1_sentences << sentence_to_json(sub_item1_sentence)
      end
    else
      sub_item1_sentences << sentence_to_json(sub_item1.fetch('Subitem1Sentence'))
    end

    {
      sub_item_num: sub_item1.fetch('Num').to_i,
      sub_item_title: sub_item1.fetch('Subitem1Title'),
      sub_item_sentences: sub_item1_sentences
    }
  end
end

# schema
  # {
  #   num: 238,
  #   caption: '（募集事項の決定）',
  #   paragraphs: [
  #     {
  #       num: 1,
  #       sentence: {
  #         honbun: '株式会社は、その発行する新株予約権を引き受ける者の募集をしようとするときは、その都度、募集新株予約権（当該募集に応じて当該新株予約権の引受けの申込みをした者に対して割り当てる新株予約権をいう。以下この章において同じ。）について次に掲げる事項（以下この節において「募集事項」という。）を定めなければならない。',
  #         tadashigaki: '',
  #       },
  #       items: [ # 第n号 を表す
  #         {
  #           item_num: 1,
  #           item_sentences: [
  #             {
  #               column_num: 1,
  #               honbun: '剰余金の配当',
  #               tadashigaki: '',
  #             },
  #             {
  #               column_num: 2,
  #               honbun: '当該種類の株主に交付する配当財産の価額の決定の方法、剰余金の配当をする条件その他剰余金の配当に関する取扱いの内容',
  #               tadashigaki: '',
  #             },
  #           ],
  #           sub_items: []
  #         },
  #         {
  #           item_num: 2,
  #           item_sentences: [
  #             {
  #               column_num: 1,
  #               honbun: '株主総会において議決権を行使することができる事項',
  #               tadashigaki: '',
  #             },
  #             {
  #               column_num: 2,
  #               honbun: '次に掲げる事項',
  #               tadashigaki: '',
  #             },
  #           ],
  #           sub_items: [
  #             {
  #               sub_item_num: 1,
  #               sub_item_title: 'イ',
  #               sub_item_sentences: [
  #                 {
  #                   column_num: 0,
  #                   honbun: '株主総会において議決権を行使することができる事項',
  #                   tadashigaki: '',
  #                 }
  #               ]
  #             },
  #             {
  #               sub_item_num: 2,
  #               sub_item_title: 'ロ',
  #               sub_item_sentences: [
  #                 {
  #                   column_num: 0,
  #                   honbun: '当該種類の株式につき議決権の行使の条件を定めるときは、その条件',
  #                   tadashigaki: '',
  #                 }
  #               ]
  #             },
  #           ]
  #         },
  #         {
  #           item_num: 1,
  #           item_sentences: [
  #             {
  #               column_num: 0,
  #               honbun: '募集新株予約権の内容及び数',
  #               tadashigaki: '',
  #             }
  #           ]
  #         },
  #         {
  #           num: 7,
  #           sentence: '前号に規定する場合において、同号の新株予約権付社債に付された募集新株予約権についての第百十八条第一項、第百七十九条第二項、第七百七十七条第一項、第七百八十七条第一項又は第八百八条第一項の規定による請求の方法につき別段の定めをするときは、その定め',
  #           tadashigaki: '',
  #         },            
  #       ]
  #     },
  #     {
  #       num: 2,
  #       sentence: '募集事項の決定は、株主総会の決議によらなければならない。',
  #       tadashigaki: '',
  #     }
  #   ]
  # }