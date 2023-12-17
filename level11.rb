Expansion = 1000000

def manhattan_distance(coord1, coord2, lines)
  row1, col1 = coord1
  row2, col2 = coord2

  first_row, second_row = [row1, row2].sort
  first_col, second_col = [col1, col2].sort

  horizontal = lines[first_row][first_col + 1..second_col]
  vertical = (first_row + 1..second_row).map do |row|
    lines[row][second_col]
  end

  distance = horizontal.count('.') + horizontal.count('#') + (horizontal.count('x') * Expansion)
  distance += vertical.count('.') + vertical.count('#') + (vertical.count('x') * Expansion)

  # puts "c1 #{coord1} c2 #{coord2}"
  # puts "h: #{horizontal}"
  # puts "v: #{vertical}"
  # puts "d: #{distance}"
  distance
  # (row2 - row1).abs + (col2 - col1).abs
end

lines = File.readlines('input.txt').map do |line|
  line.strip.chars
end

#find blank rows
empty_rows = lines.each_with_index.filter_map do |l, i|
  if l.all? { |c| c == '.' }
    i
  end
end

empty_cols = (0..lines.length).select do |col|
  lines.map { |l| l[col] }.all? { |c| c == '.' }
end


empty_rows.each do |row|
  lines[row] = Array.new(lines[row].length, 'x')
end

empty_cols.each do |col|
  lines.each do |row|
    row[col] = 'x'
  end
end

# lines.each { |x| puts x.join() }
galaxies = []

lines.each_with_index do |line, row|
  line.each_with_index do |value, col|
    if value == "#"
      galaxies << [row, col]
    end
  end
end

all = []
until galaxies.empty?
  current = galaxies.shift

  distances = galaxies.map { |g| manhattan_distance(current, g, lines)}
  all += distances
end

p all.reduce(:+)
