class Card
  attr_reader :definition , :concept
  attr_accessor :correct
  def initialize(definition, concept, correct=false)
    @definition = definition
    @concept = concept
    @correct
  end
  def to_s
    "#{@definition}"
  end
end


test_card = Card.new("Software company in Seattle", "Microsoft")
test2 = Card.new("Two plus two is...", "four")
test3 = Card.new("City in which DBC is located? (in CA)", "San Francisco")


deck = [test_card, test2, test3]

deck.each do |card|
  p card
  print "Your concept: "
  concept = gets.chomp!
  if concept == card.concept
    puts "You are correct"
    card.correct = true
  else
    puts "You should review that one"
  end
end

correct_cards = deck.select {|card| card.correct}
incorrect_cards = deck.select{|card| !card.correct}
puts "You know these really well: "
correct_cards.each {|card| puts "\t#{card}"}
puts "You should review these:"
incorrect_cards.each {|card| puts "\t#{card}"}