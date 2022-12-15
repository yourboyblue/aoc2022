ALPHA = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]

lines = File.read('day3.txt').split("\n")

score = lines.sum do |line|
  chars = line.chars
  a = chars.slice(0..chars.length / 2 - 1)
  b = chars.slice(chars.length / 2..-1)
  
  match = a & b
  ALPHA.index(match[0]) + 1
end

puts score

score = lines.each_slice(3).sum do |group|
  match = group[0].chars & group[1].chars & group[2].chars
  ALPHA.index(match[0]) + 1
end

puts score
