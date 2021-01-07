require './corporate_law/http_client'

ARGV.each do |article|
  CorporateLaw::Client.new.parse_like_real_roppo(article.to_i)
  puts "============================================" if ARGV.size > 1
end