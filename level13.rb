def parse_maps(filename)
  maps = []
  current_map = []

  File.readlines(filename).each do |line|
    if line.strip.empty?
      maps << current_map
      current_map = []
    else
      current_map << line.strip.chars
    end
  end

  if current_map.length > 0
    maps << current_map
  end

  maps
end

def find_vertical_reflection(map)
  find_horizontal_reflection(map.transpose)
end

def find_horizontal_reflection(map)
  candidates = map.each_with_index.filter_map do |row1, i1|
    differences = map.each_with_index.filter_map do |row2, i2|
      changes = row1.zip(row2).map { |r1, r2| r1 != r2 }
      if changes.count(true) == 1
        first, last = [i1, i2].sort
        { first:, last: }
      end
    end

    differences.flatten unless differences.empty?
  end.flatten.uniq

  target = candidates.filter_map do |c|
    top_i = c[:first] + 1
    bottom_i = c[:last] - 1

    is_reflection = true
    center_i = bottom_i < top_i ? c[:first] : nil

    next if bottom_i == top_i

    while bottom_i >= 0 && top_i < map.length
      if bottom_i != c[:first] && top_i != c[:last] && map[top_i] != map[bottom_i]
        is_reflection = false
        break
      end

      if !center_i && bottom_i < top_i
        center_i = bottom_i
      end

      top_i += 1
      bottom_i -= 1
    end

    if center_i && is_reflection
      center_i
    end
  end

  case target.length
  when 0
    false
  when 1
    target.first
  else
    raise "too many #{target}!"
  end
end

maps = parse_maps('input.txt')

horizontal_sum = 0
vertical_sum = 0

maps.each_with_index do |m, i|
  horizontal_reflection_index = find_horizontal_reflection(m)
  if horizontal_reflection_index
    horizontal_sum += horizontal_reflection_index + 1
  end

  vertical_reflection_index = find_vertical_reflection(m)
  if vertical_reflection_index
    vertical_sum += vertical_reflection_index + 1
  end

  raise "error! #{i}" if !vertical_reflection_index && !horizontal_reflection_index
end

puts (horizontal_sum * 100) + vertical_sum
