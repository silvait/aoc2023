require 'set'

def find_open_spot(grid, row, col)
  current_row = row - 1

  while current_row >= 0 && grid[current_row][col] == '.'
    current_row -= 1
  end

  current_row + 1
end

Cache = {}

def hash_grid(grid)
  grid.map { |r| r.join() }.join.hash
end

def tilt_grid_north(grid)
  cache_key = hash_grid(grid)
  if Cache.include? cache_key
    # puts "CACHE HIT  #{cache_key}"
    return Cache[cache_key]
  end
  new_grid = [grid[0].dup]

  grid.each_with_index do |row, index|
    next if index == 0

    new_grid << row.dup

    row.each_with_index do |cell, col|
      # puts "#{index} #{col}"

      if cell == 'O'
        current = find_open_spot(new_grid, index, col)

        # puts "#{index},#{col} -> #{current},#{col} "
        new_grid[index][col] = '.'
        new_grid[current][col] = 'O'
      end
    end
  end

  Cache[cache_key] = new_grid
  new_grid
end

def calculate_load(grid)
  total = 0

  grid.each_with_index do |row, index|
    total_rocks = row.count('O')
    weight = grid.length - index

    total += total_rocks * weight
  end

  total
end

Directions = ["North", "West", "South", "East"]
TotalCycles = 1000000000

grid = File.readlines('input.txt').map do |line|
  line.strip.chars
end

new_grid = grid
cycles = 0

results = Set.new
CycleCache = {}
chain = []

while cycles < TotalCycles
  key = hash_grid(new_grid)

  puts "#{cycles} #{calculate_load(new_grid)}"
  if CycleCache.include? key
    first_seen = CycleCache[key][:first_seen]
    cycle_length = cycles - first_seen
    puts "Cycle starts at #{first_seen} and repeats every #{cycle_length}"
    equivalent = (TotalCycles - first_seen) % cycle_length

    puts "#{TotalCycles} should be the same as #{first_seen + equivalent}"
    break
    new_grid = CycleCache[key][:result]
  else
    4.times do
      new_grid = tilt_grid_north(new_grid)
      new_grid = new_grid.transpose.map(&:reverse)
    end

    CycleCache[key] = { result: new_grid, first_seen: cycles }
  end

  cycles += 1
end
