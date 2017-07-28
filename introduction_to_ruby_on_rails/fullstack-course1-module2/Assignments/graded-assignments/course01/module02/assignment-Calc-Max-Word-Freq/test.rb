require_relative "module2_assignment"

a = LineAnalyzer.new("aaa bbb aaa bbb ccccccc ccc", 1)
puts "words: #{a.highest_wf_words}"
puts "count: #{a.highest_wf_count}"