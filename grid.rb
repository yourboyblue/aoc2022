class Grid
  include Enumerable

  attr_accessor :col_print_range
  attr_accessor :row_print_range
  attr_accessor :print_leader

  def initialize(r_max, c_max, node_class = Node)
    @node_class = node_class
    @grid = r_max.times.map { Array.new(c_max) }
    @col_print_range = 0..c_max
    @row_print_range = 0..r_max
    @print_leader = "\n\n"

    if block_given?
      r_max.times do |r|
        c_max.times do |c|
          yield self, r, c
        end
      end
    end
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

  def put(r, c, value)
    @grid[r][c] = @node_class.new(r, c, value, self)
  end

  def tl(node)
    n(node.r-1, node.c-1) unless node.r == 0 || node.c == 0
  end

  def t(node)
    n(node.r-1, node.c) unless node.r == 0
  end

  def tr(node)
    n(node.r-1, node.c+1) unless node.c == c_max || node.r == 0
  end

  def r(node)
    n(node.r, node.c+1) unless node.c == c_max
  end

  def br(node)
    n(node.r+1, node.c+1) unless node.c == c_max || node.r == r_max
  end

  def b(node)
    n(node.r+1, node.c) unless node.r == r_max
  end

  def bl(node)
    n(node.r+1, node.c-1) unless node.r == r_max || node.c == 0
  end

  def l(node)
    n(node.r, node.c-1) unless node.c == 0
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
    neighbors = [t(node), r(node), b(node), l(node)]
    neighbors.compact!
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

  def print_grid
    print print_leader
    @grid.slice(row_print_range).each do |r|
      r.slice(col_print_range).each do |c|
        print "#{c.v}"
      end
      print "\n"
    end
  end

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

    def b
      g.b(self)
    end
  
    def bl
      g.bl(self)
    end
  
    def br
      g.br(self)
    end
  end
end
