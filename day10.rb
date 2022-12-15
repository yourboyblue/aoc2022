class Instruction
  attr_reader :ticks_left, :value

  def initialize(ticks, value)
    @ticks_left = ticks
    @value = value
  end

  def dec
    @ticks_left -= 1
  end
end

class NoOp < Instruction
  def initialize
    super(1, 0)
  end

  def to_s
    "NOOP"
  end
end

class Add < Instruction
  def to_s
    "Add #{value}"
  end
end

instructions = File.read('day10.txt').split("\n")

log_cycles = [20, 60, 100, 140, 180, 220]
buffer = 6.times.map { Array.new(40, '.') }
seen = []
processing = nil
cycle = 1
register = 1

loop do
  instruction = instructions.shift unless processing && instructions.any?

  if instruction
    if instruction.match?(/^noop/)
      processing = NoOp.new
    else
      _, v = instruction.split(' ')
      v = v.to_i
      processing = Add.new(2, v)
    end
  end

  break if !processing && instructions.empty?

  processing.dec if processing 

  draw_cycle = cycle - 1
  col = draw_cycle % 40
  if ((register % 40) - col).abs <= 1
    row = draw_cycle / 40
    buffer[row][col] = '#'
  end

  cycle += 1

  if processing&.ticks_left == 0
    register += processing.value
    processing = nil
  end

  log_cycle = log_cycles.delete(cycle)
  if log_cycle
    seen << register * log_cycle
  end
end

puts seen.sum

print "\n\n"

buffer.each do |r|
  r.each do |c|
    print c
  end
  print "\n"
end
