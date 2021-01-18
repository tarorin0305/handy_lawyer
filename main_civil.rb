require './app/model/civil_law'

ARGV.each do |article|
  CivilLaw.new.parse_like_real_roppo_to_stdout(article.to_i)
  puts "============================================" if ARGV.size > 1
end