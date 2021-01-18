require './app/model/corporate_law'

ARGV.each do |article|
  CorporateLaw.new.parse_like_real_roppo_to_stdout(article.to_i)
  puts "============================================" if ARGV.size > 1
end