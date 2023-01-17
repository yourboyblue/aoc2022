require 'pry'
require 'set'

input = File.read('day15.txt')

re = /x=([-\d]+), y=([-\d]+).*x=([-\d]+), y=([-\d]+)/

# parse input into signal/beacon pairs
pairs = input.split("\n").map do |line|
  sx, sy, bx, by = line.match(re).captures
  [[sx.to_i, sy.to_i], [bx.to_i, by.to_i]]
end

def manhattan(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

target_y = 2000000 # row target

checked = []

# This is still fairly slow. 
# It could be refactored to use range checking strategy from pt 2 rather than checking each point.
pairs.each do |s, b|
  m = manhattan(s, b)
  # check right
  x = s[0]
  loop do 
    check = [x, target_y]
    if m >= manhattan(s, check)
      checked << check 
      x += 1
    else 
      break
    end
  end

  # check left
  x = s[0] - 1
  loop do 
    check = [x, target_y]
    if m >= manhattan(s, check)
      checked << check 
      x -= 1
    else 
      break
    end
  end
end

checked.uniq! # de-dupe
beacons = pairs.map(&:last)
checked -= beacons

puts checked.length

#### PART 2 ####

MAX = 4_000_000

# sensors paired with their known manhattan range
pairs_m = pairs.map { |s, b| [s, manhattan(s, b)] }

# for a known sensor + row, what range did the sensor search?
def m_slice(sensor, manhattan, y)
  extra = manhattan - (sensor[1] - y).abs
  [[0, sensor[0] - extra].max,[sensor[0] + extra, MAX].min]
end

range_order = ->(a, b) do
  first_element_check = a[0] - b[0]
  return first_element_check if first_element_check != 0

  a[1] - b[1]
end

def cover?(a, b)
  a[0] <= b[0] && b[1] <= a[1]
end

def discontinuous?(a, b)
  a[1] < (b[0] - 1)
end

y = 0
x = nil

loop do
  # reject sensors that are too far away to sense the current row
  applicable_sensors = pairs_m.reject { |sensor, manhattan| manhattan - (sensor[1] - y).abs < 0 }
  
  # find the ranges covered in the current row by applicable sensors
  covered = applicable_sensors.map { |sensor, manhattan| m_slice(sensor, manhattan, y) }
  
  # sort ranges by x start, then by longest first
  covered.sort!(&range_order)

  # ignore ranges completely covered by another range
  merged = covered.each_with_object([]).with_index do |(range, acc), i|
    if i > 0
      acc << range unless cover?(acc.last, range)
    else 
      acc << range
    end
  end

  # check if the row is covered by continuous ranges -- if not, the beacon is in the gap
  gap = merged.each_cons(2).map.find { |a, b| discontinuous?(a, b) }
  if gap
    x = gap[1][0] - 1
    break
  end

  y += 1
end

puts x * 4_000_000 + y
