lines = File.read('day4.txt').split("\n")
ranges = lines.map { |l| l.split(/[,-]/).map(&:to_i) }

def cover?(a, b, c, d)
  (a <= c && d <= b) || (c <= a && b <= d)
end

def intersect?(a, b, c, d)
  (a <= c && c <= b) || (c <= a && a <= d)
end

score = 0
ranges.each do |(a, b, c, d)|
  score += 1 if cover?(a, b, c, d)
end

puts score

score = 0 
ranges.each do |(a, b, c, d)|
  score += 1 if intersect?(a, b, c, d)
end
puts score
