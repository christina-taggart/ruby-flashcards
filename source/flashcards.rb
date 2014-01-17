module CardFactory
  def self.create_card(flashcard_data) # ["Software company in Seattle", "Microsoft"]
    Card.new(flashcard_data[0], flashcard_data[1])
  end
end

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

class Deck
  attr_reader :cards
  def initialize(cards)
    @cards = cards #this is an array of card objects
  end
end

# factory_test = CardFactory.create_card(["Software company in Seattle", "Microsoft"])
# p factory_test

class Quiz
  def initialize(deck)
    @deck = deck
  end
  def quiz!
    @deck.cards.each do |card|
      p card
      print "Concept: "
      answer = gets.chomp!
      check_answer(answer, card)
    end
    correct_or_not
    display_results
  end
  def check_answer(answer, card)
    if answer == card.concept
      puts "You are correct"
      card.correct = true
    else
      puts "You should review that one"
    end
  end
  def correct_or_not
    @correct_cards = @deck.cards.select {|card| card.correct}
    @incorrect_cards = @deck.cards.select{|card| !card.correct}
  end
  def display_results
    puts "You know these really well: "
    @correct_cards.each {|card| puts "\t#{card}"}
    puts "You should review these:"
    @incorrect_cards.each {|card| puts "\t#{card}"}
  end
end

class Controller

  def initialize
    #make cards?
    @card_content_array = []
  end

  def format_txt_file
    File.readlines("flashcard_samples.txt").each_slice(3){|s|
      p @card_content_array = [s[0].strip, s[1].strip]
      }
  end

end


test1 = Card.new("Software company in Seattle", "Microsoft")
test2 = Card.new("Two plus two is...", "four")
test3 = Card.new("City in which DBC is located? (in CA)", "San Francisco")

deck = Deck.new([test1, test2, test3])

quiz = Quiz.new(deck)
quiz.quiz!

# deck.each do |card|
#   p card
#   print "Concept: "
#   concept = gets.chomp!
#   if concept == card.concept
#     puts "You are correct"
#     card.correct = true
#   else
#     puts "You should review that one"
#   end
# end

# correct_cards = deck.select {|card| card.correct}
# incorrect_cards = deck.select{|card| !card.correct}
# puts "You know these really well: "
# correct_cards.each {|card| puts "\t#{card}"}
# puts "You should review these:"
# incorrect_cards.each {|card| puts "\t#{card}"}