File.read('day1.txt').split("\n\n").max { |elf| elf.split("\n").map(&:to_i).sum }.max
File.read('day1.txt').split("\n\n").map { |elf| elf.split("\n").map(&:to_i).sum }.sort.last(3).sum
