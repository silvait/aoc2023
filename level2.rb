def parse_line(line)
    game, details = line.split(':')
    _, id = game.split(' ')

    drawings = details.split(';').map do |d|
        cubes = d.split(',')
        
        obj = {}
        cubes.map do |c|
            num, color = c.split(' ')
            obj[color] = num.to_i
        end
        obj
    end

    { id: id.to_i, drawings: }
end

limits = {
    "red" => 12,
    "green" => 13,
    "blue" => 14
}

lines = File.readlines('sample.txt')
games = lines.map { |line| parse_line(line) }
valid_games = games
    .map do |g| 
        drawings = g[:drawings]
        min_set = { "red" => 0, "green" => 0, "blue" => 0 }

        drawings.each do |d| 
            d.keys.each do |k|
                if d[k] > min_set[k]
                    min_set[k] = d[k]
                end
            end
        end

        min_set["red"] * min_set["blue"] * min_set["green"]
    end
    .inject(0, :+)
puts valid_games