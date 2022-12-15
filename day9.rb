def follower_must_move(h, t)
  (t[0] - h[0]).abs > 1 || (t[1] - h[1]).abs > 1
end

def move_follower(l, f)
  f[0] -= 1 if f[0] > l[0]
  f[0] += 1 if f[0] < l[0]
  f[1] -= 1 if f[1] > l[1]
  f[1] += 1 if f[1] < l[1]
end

def move_head(h, direction)
  case direction
  when 'U' then h[1] += 1
  when 'D' then h[1] -= 1
  when 'L' then h[0] -= 1
  when 'R' then h[0] += 1
  end
end

seen = [[0,0]]
h = [0, 0]
t = [0, 0]

File.read('day9.txt').split("\n").each do |move|
  d, n = move.split(' ')
  n = n.to_i
  n.times do 
    move_head(h, d)

    if follower_must_move(h, t)
      move_follower(h, t)
    end 

    seen << t.dup
  end
end

puts seen.uniq.length

seen = [[0,0]]
knots = 10.times.map { [0, 0] }
h = knots.first 
t = knots.last 

File.read('day9.txt').split("\n").each do |move|
  d, n = move.split(' ')
  n = n.to_i
  n.times do 
    move_head(h, d)

    knots.each_cons(2) do |l, f|
      if follower_must_move(l, f)
        move_follower(l, f)
      end 
    end
    
    seen << t.dup
  end
end

puts seen.uniq.length
