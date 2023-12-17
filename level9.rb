def calculate_pattern(sequence)
  return 0 if sequence.all? { |x| x == 0 }

  delta_patterns = sequence.each_cons(2).map { |a, b| b - a }
  sequence.last + calculate_pattern(delta_patterns)
end

next_numbers = File.readlines('input.txt').map do |line|
  sequence = line.strip.split.map(&:to_i)
  calculate_pattern(sequence)
end

puts next_numbers.reduce(:+)
