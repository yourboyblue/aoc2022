class AocDir
  attr_reader :dirs, :files, :name

  def initialize(name)
    @name = name
    @dirs = []
    @files = []
  end

  def size
    @size ||= files.sum(&:size) + dirs.sum(&:size)
  end
end

class AocFile
  attr_reader :size 
   
  def initialize(name, size)
    @name = name
    @size = size
  end
end


class AocReader
  attr_reader :dirs

  def initialize
    @dirs = []
    @stack = []
  end

  def process(command)
    case command
    when /^\$ cd \.\.$/
      @stack.pop
    when /^\$ cd [^\d\s]+/
      dir_name = command.match(/\$ cd ([^\d\s]+)/).captures.first
      current_dir = @stack.last
      dir = AocDir.new(dir_name)
      @dirs.push(dir)
      @stack.last.dirs << dir if @stack.last
      @stack.push(@dirs.last)
    when /^\d+/
      current_dir = @stack.last
      file_name = command.match(/([^\d\s]+)/).captures.first
      size = command.match(/^(\d+)/).captures.first
      current_dir.files << AocFile.new(file_name, size.to_i)
    end
  end

  def root
    dirs.first
  end
end

commands = File.read('day7.txt').split("\n")

reader = AocReader.new
commands.each do |c|
  reader.process(c)
end

targets = reader.dirs.select { |d| d.size <= 100000 }
puts targets.sum(&:size)

puts "\n\nPart 2\n\n"

required_space = 30000000 - (70000000 - reader.root.size)
puts reader.dirs.sort_by(&:size).find { |d| d.size >= required_space }.size
