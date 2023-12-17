cards = File.readlines('input.txt').map do |l|
    card, details = l.split(': ')
    card_id = card.sub('Card ', '').to_i
    winning_str, numbers_str = details.split(' | ')
    winning_numbers = winning_str.split(' ').map(&:to_i)
    card_numbers = numbers_str.strip.split(' ').map(&:to_i)

    matches = card_numbers.map { |n| winning_numbers.include?(n) ? 1 : 0 }.inject(0, :+)
    copies = ((card_id + 1)..(card_id + matches)).to_a

    { id: card_id, winning_numbers:, numbers: card_numbers, matches:, copies: }
end

winnings = cards.map { |c| c[:id] }

cards.each do |c| 
    total_copies = winnings.count(c[:id])
    winnings += (c[:copies] * total_copies)
end

puts winnings.length