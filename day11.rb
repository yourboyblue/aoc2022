class Monkey
  attr_reader :inspected, :test_value

  def self.from_input(input)
    input = input.dup
    input.shift # we don't care about this first line
    items = input.shift.scan(/\d+/).map(&:to_i)
    op, value = input.shift.match(/([+*])\s(\d+|old)/).captures
    value = value.to_i unless value == 'old'
    test_value = input.shift.scan(/\d+/).first.to_i
    to_on_true = input.shift.scan(/\d+/).first.to_i
    to_on_false = input.shift.scan(/\d+/).first.to_i
    new(items, op, value, test_value, to_on_true, to_on_false)
  end

  def initialize(items, op, value, test_value, to_on_true, to_on_false)
    @items = items
    @op = op
    @value = value
    @test_value = test_value
    @to_on_true = to_on_true
    @to_on_false = to_on_false
    @inspected = 0
  end

  def update_worry(item, worry_variant = 1)
    case @op
    when '+' 
      @value == 'old' ? item += item : item += @value
    when '*'
      @value == 'old' ? item *= item : item *= @value
    else 
      raise 'WAT'
    end
    
    if worry_variant == 1
      item / 3
    else
      item % worry_variant 
    end 
  end

  def throw(item)
    if item % @test_value == 0
      [@to_on_true, item]
    else
      [@to_on_false, item]
    end
  end

  def inspect_items(worry_variant = 1)
    @items.each_with_index do |item, i|
      @inspected += 1
      yield throw(update_worry(item, worry_variant))
    end

    @items = []
  end

  def add_item(item)
    @items << item
  end
end

blueprint = File.read('day11.txt')
input = blueprint.split("\n\n").map { |m| m.split("\n").reject { |l| l == '' }.map(&:strip) }

monkeys = input.map { |str| Monkey.from_input(str) }

20.times do 
  monkeys.each do |monkey|
    monkey.inspect_items do |to, item|
      monkeys[to].add_item(item)
    end
  end
end

a, b = monkeys.sort_by(&:inspected).last(2)
puts a.inspected * b.inspected

monkeys = input.map { |str| Monkey.from_input(str) }

gcm = monkeys.reduce(1) { |acc, m| acc * m.test_value }

10000.times do 
  monkeys.each do |monkey|
    monkey.inspect_items(gcm) do |to, item|
      monkeys[to].add_item(item)
    end
  end
end

a, b = monkeys.sort_by(&:inspected).last(2)
puts a.inspected * b.inspected
