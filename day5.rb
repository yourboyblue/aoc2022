crates = [
  [],
  %w[G F V H P S],
  %w[G J F B V D Z M],
  %w[G M L J N],
  %w[N G Z V D W P],
  %w[V R C B],
  %w[V R S M P W L Z],
  %w[T H P],
  %w[Q R S N C H Z V],
  %w[F L G P V Q J],
]

lines = File.read('day5.txt').split("\n")

lines.each do |line|
  count, source, dest = line.scan(/\d+/).map(&:to_i)
  count.times do 
    crates[dest].push(crates[source].pop)
  end
end

crates.each { |crate| puts "[#{crate.join(', ')}]" }
puts crates.map(&:last).compact.join('')
puts("\n\n")

crates = [
  [],
  %w[G F V H P S],
  %w[G J F B V D Z M],
  %w[G M L J N],
  %w[N G Z V D W P],
  %w[V R C B],
  %w[V R S M P W L Z],
  %w[T H P],
  %w[Q R S N C H Z V],
  %w[F L G P V Q J],
]

lines.each do |line|
  count, source, dest = line.scan(/\d+/).map(&:to_i)
  start = crates[source].length - count
  start = 0 if start < 0
  stack = crates[source].slice!(start, count) 
  crates[dest].push(*stack)
end

crates.each { |crate| puts "[#{crate.join(', ')}]" }
puts crates.map(&:last).compact.join('')
