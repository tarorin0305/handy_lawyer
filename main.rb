require './corporate_law/http_client'

article = ARGV[0].to_i
CorporateLaw::Client.new.parse_like_real_roppo(article)