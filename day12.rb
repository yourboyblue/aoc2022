require 'pry'

class Node
  attr_accessor :r, :c, :v, :g

  def initialize(r,c,v,g)
    @r = r
    @c = c
    @v = v
    @g = g
  end

  def inspect
    "<#{self.class} row=#{r} col=#{c} value=#{v}>"
  end

  def to_s
    inspect
  end
end

class AStarNode < Node
  attr_accessor :came_from, :g_score, :f_score
  
  def path
    @path ||= find_path
  end

  def find_path
    p = [self]
    loop do
      came_from = p.first.came_from
      break if came_from.nil?
      p.unshift(came_from)
    end
    p
  end
end

class DayTwelveNode < AStarNode
  def neighbors
    g.neighbors_90(self).select { |n| v.ord - n.v.ord >= -1 }
  end
end

class DayTwelveNodeTwo < AStarNode
  def neighbors
    g.neighbors_90(self).select { |n| v.ord - n.v.ord <= 1 }
  end
end

class Grid
  include Enumerable

  def initialize(raw, node_class = Node)
    @node_class = node_class
    @grid = parse_raw(raw)
  end

  def rows
    @grid
  end

  def each
    @grid.each do |r|
      r.each do |c|
        yield c
      end
    end
  end

  def n(r, c)
    @grid[r][c]
  end

  def r_max
    @r_max ||= @grid.length - 1
  end

  def c_max
    @c_max ||= @grid[0].length - 1
  end

  def neighbors_90(node)
    neighbors = []
    neighbors << n(node.r-1, node.c) unless node.r == 0 # up
    neighbors << n(node.r+1, node.c) unless node.r == r_max # down
    neighbors << n(node.r, node.c-1) unless node.c == 0 # left
    neighbors << n(node.r, node.c+1) unless node.c == c_max # right
    neighbors
  end

  def parse_raw(raw)
    g = []
    raw.each_with_index do |row, ri|
      g << [] 
      row.chars.each_with_index do |v, ci|
        g[ri] << @node_class.new(ri, ci, v, self)
      end
    end
    g
  end
end

class ScreenPrinter
  def initialize
    # clear and move to 0,0
    print("\033[2J") 
    @pr = 0 
    @pc = 0
  end

  # print at coordinates
  def print_c(r, c, char, color=nil, duration=nil)
    code = case color
    when :red then 31
    when :green then 32
    when :yellow then 33
    when :blue then 34
    when :pink then 35
    when :light_blue then 36
    end

    move_to(r, c)
    print (code ? "\e[#{code}m#{char}\e[0m" : char)
    @pc += 1
    sleep duration if duration
  end

  def move_to(to_r, to_c)
    if to_r != @pr
      r = @pr - to_r
      y = r < 0 ? 'B' : 'A' 
      print("\033[#{r.abs}#{y}")
      @pr = to_r
    end
      
    if to_c != @pc
      c = @pc - to_c
      x = c < 0 ? 'C' : 'D' 
      print("\033[#{c.abs}#{x}")
      @pc = to_c
    end
  end

  def newline
    print("\n")
    @pr +=1
  end

  def coords
    puts "#{@pc}, #{@pr}"
  end
end

class PriorityQueue
  def initialize
    @q = {}
  end

  def push(item, score)
    @q[item] = score
  end

  def pop
    item, _ = @q.min_by { |_, score| score }
    @q.delete(item)
    item
  end

  def score(item)
    @q[item].to_i
  end

  def include?(n)
    @q.include?(n)
  end

  def any?
    @q.any?
  end

  def to_s
    @q.keys.map(&:to_s).join(', ')
  end
end

def a_star(grid, start, goal, heuristic, printer=nil)
  open_set = PriorityQueue.new
  start.g_score = 0
  start.f_score = heuristic.call(start, goal)
  open_set.push(start, start.f_score)

  while open_set.any?
    current = open_set.pop
    return current if current == goal
    printer.print_c(current.r, current.c, 'X', :light_blue, 0.01) if printer

    current.neighbors.each do |neighbor|
      tentative_score = current.g_score + 1 # 1 would be the edge weight, like, if terrain varies
      if neighbor.g_score.nil? || tentative_score < neighbor.g_score
        new_f_score = tentative_score + heuristic.call(neighbor, goal)
        if !open_set.include?(neighbor) || new_f_score < open_set.score(neighbor)
          neighbor.came_from = current
          neighbor.g_score = tentative_score
          neighbor.f_score = new_f_score
          open_set.push(neighbor, neighbor.f_score)
        end
      end
    end

    printer.print_c(current.r, current.c, '*', :red) if printer
  end

  raise 'NOT FOUND' unless goal == nil
end

heuristic = -> (node, goal) { (node.r - goal.r).abs + (node.c - goal.c).abs }

raw = [
  'Sabqponm',
  'abcryxxl',
  'accszExk',
  'acctuvwj',
  'abdefghi'
]

raw = File.read('day12.txt').split("\n")

# grid = Grid.new(raw, DayTwelveNode)
# start = grid.find { |node| node.v == 'S' }
# goal = grid.find { |node| node.v == 'E' }
# start.v = 'a'
# goal.v = 'z'

# printer = ScreenPrinter.new
# grid.rows.each do |row|
#   row.each do |node|
#     if node == goal
#       printer.print_c(node.r, node.c, 'Z', :yellow) 
#     else
#       printer.print_c(node.r, node.c, node.v)
#     end
#   end
#   printer.newline
# end

# found = a_star(grid, start, goal, heuristic, printer)

# printer.move_to(grid.rows.length + 2, 0)
# puts found.path.length - 1

# part 2

grid = Grid.new(raw, DayTwelveNodeTwo)
start = grid.find { |node| node.v == 'E' }
start.v = 'z'
old_start = grid.find { |node| node.v == 'S' }
old_start.v = 'a'

printer = ScreenPrinter.new
grid.rows.each do |row|
  row.each do |node|
    printer.print_c(node.r, node.c, node.v)
  end
  printer.newline
end

class Heuristic
  def initialize
    @counter = 9223372036854775807
  end

  def call(*)
    @counter -= 1
  end
end

# visit without returning a specific path
a_star(grid, start, nil, Heuristic.new, printer)

binding.pry



