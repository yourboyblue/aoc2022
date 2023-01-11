require 'pry'
require 'set'

input = File.read('day12.txt')
grid = input.split("\n").map(&:chars)

def neighbors(grid, r, c)
  c_max = grid.first.length - 1
  r_max = grid.length - 1

  at_right_angles = [
    [bracket(0, r_max, r - 1), c],
    [bracket(0, r_max, r + 1), c],
    [r, bracket(0, c_max, c - 1)],
    [r, bracket(0, c_max, c + 1)],
  ]

  # remove self
  at_right_angles.delete([r, c])

  # remove neighbors more than one step down (we're starting from the finish node)
  at_right_angles.select do |cr, cc|
    elevation = n_value(grid[cr][cc]).ord - n_value(grid[r][c]).ord
    elevation >= -1
  end
end

def bracket(low, high, value)
  return low if value < low
  return high if value > high

  value
end

def n_value(value)
  case value
  when 'S' then 'a'
  when 'E' then 'z'
  else
    value
  end
end

v_start = nil
v_end = nil

grid.length.times do |r| 
  grid.first.length.times do |c|
     v_start = [r,c] if grid[r][c] == 'S'
     v_end = [r,c] if grid[r][c] == 'E'
  end
end

seen = Set.new([v_end])
dist = 0

batch = [v_end]

while batch.any?
  next_batch = batch.flat_map { |node| neighbors(grid, *node) }
  next_batch.uniq!
  next_batch.reject! { |n| seen.include?(n) }

  break dist += 1 if next_batch.any? { |r, c| n_value(grid[r][c]) == 'a'}

  seen.merge(next_batch)
  batch = next_batch
  dist += 1
end

puts dist
