lines = File.readlines('input.txt')

instructions = lines.first.strip.chars.map do |c|
  if c == 'R'
    1
  elsif c == 'L'
    0
  else
    print "ERROR: #{c}"
    nil
  end
end

maps = {}
lines[1..].map do |l|
  next if l.strip.empty?

  node, paths = l.split(' = ')
  left_path = paths[1..3]
  right_path = paths[6..8]

  maps[node] = [left_path, right_path]
end

StartNode = 'A'
EndNode = 'Z'

current_step = 0

current_nodes = maps.select { |n| n.end_with? StartNode }.map(&:first)
cache = {}

puts "START: #{current_nodes}"
until current_nodes.all? { |n| n.end_with? EndNode }
  next_path = instructions[current_step % instructions.length]

  current_nodes.each_with_index do |el, i|
    cache_line = "#{i}-#{el}-#{current_step % instructions.length}"
    if cache[cache_line]
      puts "SEEN #{cache_line} @ #{cache[cache_line][:delta]}"
      cache[cache_line][:delta] << (current_step - cache[cache_line][:seen_at].last)
      cache[cache_line][:seen_at] << current_step
    else
      cache[cache_line] = { seen_at: [current_step], delta: [] }
    end
  end

  # puts "node: #{current_nodes} step: #{current_step} next: #{next_path}"
  current_nodes = current_nodes.map { |n| maps[n][next_path] }
  current_step += 1
end

puts current_step
