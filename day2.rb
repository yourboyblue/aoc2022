score = 0

def score(a, b)
  case [a, b]
  when ['A', 'X'] then 3
  when ['A', 'Y'] then 6
  when ['A', 'Z'] then 0
  when ['B', 'X'] then 0
  when ['B', 'Y'] then 3
  when ['B', 'Z'] then 6
  when ['C', 'X'] then 6
  when ['C', 'Y'] then 0
  when ['C', 'Z'] then 3
  end
end

File.new('day2.txt').each_line do |line|
  a, b = line.split(' ')
  case b
  when 'X' then score += 1
  when 'Y' then score += 2
  when 'Z' then score += 3
  end

  score += score(a, b)
  # puts "#{a} #{b} #{score}"
end

puts score

score = 0
def score2(a, b)
  case [a, b]
  when ['A', 'X'] then 3
  when ['A', 'Y'] then 1
  when ['A', 'Z'] then 2
  when ['B', 'X'] then 1
  when ['B', 'Y'] then 2
  when ['B', 'Z'] then 3
  when ['C', 'X'] then 2
  when ['C', 'Y'] then 3
  when ['C', 'Z'] then 1
  end
end

File.new('day2.txt').each_line do |line|
  a, b = line.split(' ')
  case b
  when 'X' then score += 0
  when 'Y' then score += 3
  when 'Z' then score += 6
  end

  score += score2(a, b)
  # puts "#{a} #{b} #{score}"
end

puts score
