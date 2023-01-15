require 'pry'
require_relative 'grid'

class CaveNode < Grid::Node
  def air?
    v == '.'
  end
  
  def air!
    @v = '.'
  end

  def rock?
    v == '#'
  end

  def sand!
    @v = 'o'
  end

  def falling!
    @v = '+'
  end

  def sand?
    v == 'o'
  end
  
  def filled?
    rock? || sand?
  end

  def left_border?
    c == 0
  end

  def right_border?
    c == g.c_max
  end

  def next_open_point
    candidates = [b, bl, br]
    candidates.compact!
    candidates.find(&:air?)
  end

  def will_escape?
    r == g.r_max
  end
end

# example input
# input = <<~IN
# 498,4 -> 498,6 -> 496,6
# 503,4 -> 502,4 -> 502,9 -> 494,9
# IN

input = File.read('day14.txt')

dividers = /(\s->\s|,)/
rock_points = input.split("\n").flat_map do |line|
  point_values = line.split(dividers).reject { |c| c.match?(dividers) }.map(&:to_i)
  points = point_values.each_slice(2).map { |c, r| [c, r] }

  points.each_cons(2).flat_map do |a, b|
    col_diff = (a[0] - b[0]).abs
    row_diff = (a[1] - b[1]).abs

    if col_diff > 0
      col_min, col_max = [a[0], b[0]].sort
      c_points = (col_min..col_max).to_a
      r_points = (col_diff+1).times.map { a[1] }
      c_points.zip(r_points)
    else
      row_min, row_max = [a[1], b[1]].sort
      r_points = (row_min..row_max).to_a
      c_points = (row_diff+1).times.map { a[0] }
      c_points.zip(r_points)
    end
  end
end

col_max = rock_points.map(&:first).max
row_max = rock_points.map(&:last).max

grid = Grid.new(row_max+1, col_max+1, CaveNode) do |g, row, col|
  g.put(row, col, '.') # default node, no rock fill
end

rock_points.each do |c, r| 
  grid.put(r, c, '#')
end

def find_rest_point(grid, part)
  col = 500
  col += grid.left_shift if part == 2

  # Are all valid gaps filled with sand?
  node = grid.n(0, col)
  return if node.filled?

  node.falling!

  loop do
    if node.will_escape?
      node = nil
      break
    else
      if part == 2
        grid.expand_left! if node.left_border?
        grid.expand_right! if node.right_border?
      end 

      next_node = node.next_open_point
      if next_node
        node.air!
        next_node.falling!
        node = next_node
      else
        node.sand!
        break
      end
    end
  end

  return node
end

def simulate(grid, part: 1)
  loop do 
    filled = find_rest_point(grid, part)
    break unless filled
  end
end

simulate(grid)
puts grid.count { |n| n.sand? }

# The change for part 2 makes the grid potentially infinitely expansive on the x-axis. Here we override the base class
# to allow expansion left or right while keeping everything 0-indexed. Expanding by one cell at a time quite slow
# (though fine to solve this problem.) A perf refactor would be to buffer space by some larger value every time
# expansion was necessary.
class Part2Grid < Grid
  attr_reader :left_shift

  def initialize(...)
    super(...)
    @left_shift = 0
  end

  def expand_left!
    each { |node| node.c += 1 }
    @grid.each_with_index { |row, i| row.unshift(@node_class.new(i, 0, '.', self)) }
    @c_max += 1
    @grid.last.first.v = '#' # floor expands to infinity
    @left_shift += 1 # record the offset so we can keep the grid zero indexed
  end

  def expand_right!
    @c_max += 1
    @grid.each_with_index { |row, i| row << @node_class.new(i, c_max, '.', self) }
    @grid.last.last.v = '#' # floor expands to infinity
  end
end

col_max = rock_points.map(&:first).max
row_max = rock_points.map(&:last).max + 2

# add the floor path
floor_points = (col_max + 1).times.map { |i| [i, row_max] }
rock_points.concat(floor_points)

grid = Part2Grid.new(row_max+1, col_max+1, CaveNode) do |g, row, col|
  g.put(row, col, '.') # default node, no rock fill
end

rock_points.each do |c, r| 
  grid.put(r, c, '#')
end

simulate(grid, part: 2)
puts grid.count { |n| n.sand? }
