# Spring States
Damaged = '#'
Operational = '.'
Unknown = '?'

UnfoldCount = 5

def unfold(springs, blocks)
  [([springs] * UnfoldCount).join(Unknown), (blocks * UnfoldCount)]
end

FieldsSeparator = ' '
BlockSeparator = ','

def parse_line(line)
  springs, blocks = line.split(FieldsSeparator)
  [springs, blocks.split(BlockSeparator).map(&:to_i)]
end

def do_calculations(springs, blocks, spring_index, block_index, current_count, cache)
  cache_key = [spring_index, block_index, current_count]
  return cache[cache_key] if cache.include? cache_key

  if spring_index == springs.length
    if block_index == blocks.length && current_count == 0
      return 1
    elsif block_index == blocks.length - 1 && blocks[block_index] == current_count
      return 1
    else
      return 0
    end
  end

  total = 0
  current_spring = springs[spring_index]
  next_spring_index = spring_index + 1

  if [Operational, Unknown].include? current_spring
    if current_count == 0
      total += do_calculations(springs, blocks, next_spring_index, block_index, 0, cache)
    elsif blocks[block_index] == current_count
      total += do_calculations(springs, blocks, next_spring_index, block_index + 1, 0, cache)
    end
  end

  if [Damaged, Unknown].include? current_spring
    total += do_calculations(springs, blocks, next_spring_index, block_index, current_count + 1, cache)
  end

  cache[cache_key] = total
end

def calculate_possibilities(springs, blocks)
  do_calculations(springs, blocks, 0, 0, 0, {})
end

total = 0

File.readlines('input.txt').each do |line|
  springs, blocks = parse_line(line)
  unfolded_springs, unfolded_blocks = unfold(springs, blocks)
  total += calculate_possibilities(unfolded_springs, unfolded_blocks)
end

puts total
