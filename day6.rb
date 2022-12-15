buffer = File.read('day6.txt')

i = 0
buffer.chars.each_cons(4) do |block|
  break if block == block.uniq
  i += 1
end

puts 4 + i 

i = 0
buffer.chars.each_cons(14) do |block|
  break if block == block.uniq
  i += 1
end

puts 14 + i 
