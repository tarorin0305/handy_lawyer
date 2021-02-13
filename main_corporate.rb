require './app/model/corporate_law'

if ARGV.size > 1
  start_article = ARGV[0].to_i
  end_article = ARGV[1].to_i
  start_article.upto(end_article) do |i|
    CorporateLaw.new.parse_like_real_roppo_to_stdout(i)
    puts "============================================"
    sleep 1
  end
else
  CorporateLaw.new.parse_like_real_roppo_to_stdout(ARGV[0])
end