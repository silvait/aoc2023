def parse_file(filename)
  lines = File.readlines(filename)
  _, time = lines[0].strip.gsub(/\s+/, '').split(':')
  race_time = time.to_i

  _, distances = lines[1].strip.gsub(/\s+/, '').split(':')

  race_distance = distances.to_i
  { time: race_time, distance: race_distance }
end

def calculate_strategies(race)
  time = race[:time]
  distance = race[:distance]
  (0..time).map do |x|
    hold = time - x
    move = x
    hold * move
  end.filter { |x| x > distance }.length
end

race = parse_file('input.txt')
p calculate_strategies(race)
