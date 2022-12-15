require 'pry'

class Tree
  attr_reader :height, :scenic_score

  def initialize(height)
    @height = height
    @visible = false
    @scenic_score = 1
  end

  def visible!
    @visible = true
  end

  def visible?
    @visible
  end

  def multiply_score(score)
    @scenic_score *= score
  end
end

# we can keep all the logic the same by rotating the grid after traversing
def rotate(grid)
  grid.transpose.map(&:reverse)
end

trees = []
tree_grid = File.read('day8.txt').split("\n").map do |line|
  line.chars.map { |h| trees << Tree.new(h.to_i); trees.last }
end

4.times do
  tree_grid.each do |r|
    mh = 0
    r.each_with_index do |tree, j|
      if tree.height > mh || j == 0
        tree.visible! 
        mh = tree.height
      end
    end
  end
  tree_grid = rotate(tree_grid)
end

count = 0
tree_grid.each do |r|
  r.each do |tree|
    count += 1 if tree.visible?
  end
end

# Print the grid with visible trees highlighted
# tree_grid.each do |r|
#   r.each_with_index do |tree|
#     c = tree.visible? ? "\e[41m#{tree.height}\e[0m" : tree.height
#     print c
#   end
#   print "\n"
# end

puts trees.count(&:visible?)

4.times do
  tree_grid.each do |r|
    r.each_with_index do |tree, j|
      score = 0
      loop do
        j -= 1
        break if j < 0
        score += 1
        break if tree.height <= r[j].height
      end
      tree.multiply_score(score)
    end
  end
  tree_grid = rotate(tree_grid)
end

puts trees.max_by(&:scenic_score).scenic_score
