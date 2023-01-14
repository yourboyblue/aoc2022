require 'pry'
require_relative 'grid'

class CaveNode < Grid::Node
  def air?
    v == '.'
  end

  def rock?
    v == '#'
  end

  def sand?
    v == 'o'
  end
  
  def filled?
    rock? || sand?
  end
end

input = <<~IN
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
IN

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

col_min = rock_points.map(&:first).min
grid.print_grid(c_range: col_min..col_max)



