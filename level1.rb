def words_to_number(line)
    replacement_rules = {
        'one' => '1',
        'two' => '2',
        'three' => '3',
        'four' => '4',
        'five' => '5',
        'six' => '6',
        'seven' => '7',
        'eight' => '8',
        'nine' => '9',
    }

    words = replacement_rules.keys
    new_line = ''
    until line.nil?
        replace = words.find do |w|
            line.start_with? w 
        end

        if replace
            new_line += replacement_rules[replace]
            # line.sub!(replace, '')
        else
            new_line += line[0,1]
        end
        line = line[1..-1]
    end

    puts new_line
    new_line
end

numbers = File.readlines('input.txt').map do |line|
    nums = words_to_number(line).chars.select do |c|
        c =~ /\d/
    end

    (nums.first.to_i * 10) + nums.last.to_i
end

puts numbers.length
puts numbers.inject(0, :+)