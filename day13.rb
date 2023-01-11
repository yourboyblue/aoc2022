# Could eval or JSON.parse here, but had fun writing the parser
def parse_input(str)
  # char position
  i = 0

  # track nesting
  stack = []

  # hold digit chars
  n = nil 

  while c = str[i]
    i += 1

    case c
    when '['
      prev = stack.last
      stack << []
      prev << stack.last if prev 
    when ','
      stack.last << n.to_i if n
      n = nil
    when ']'
      stack.last << n.to_i if n
      n = nil
      stack.pop if stack.length > 1
    when /\d/
      n = '' unless n
      n << c 
    end
  end

  stack.last
end

def check_pair(a, b)
  return -1 if !a
  return 1 if !b

  if a.is_a?(Array) || b.is_a?(Array)
    a = [a] if a.is_a?(Integer)
    b = [b] if b.is_a?(Integer)
    return check_arrays(a, b)
  end  
  
  a <=> b
end

def check_arrays(a, b)  
  i = 0

  while a[i] || b[i]
    c = check_pair(a[i], b[i])
    return c if c != 0
    i += 1
  end

  0
end

input = File.read('day13.txt')
lines = input.split("\n").reject { |l| l == '' }.map { |l| parse_input(l) }

valids = []
lines.each_slice(2).with_index do |(a, b), i|
  valids << i + 1 if check_pair(a, b) == -1
end

puts valids.sum

lines << [[2]]
lines << [[6]]
lines = lines.sort { |a, b| check_pair(a, b) }
index_2 = lines.index([[2]]) + 1
index_6 = lines.index([[6]]) + 1

puts index_2 * index_6
