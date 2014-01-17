require 'csv'
class Card
  attr_accessor :definition, :word
  def initialize(definition, word)
    @definition = definition
    @word = word
  end
end

class Deck
  attr_accessor :deck
  def initialize(file = ARGV[0])
    @deck = []
    @file = file
    fill_deck
  end

  def fill_deck
  CSV.read(@file).map do |row|
   @deck << Card.new(row[0], row[1])
    end
  end
end


class Quiz
  def initialize
    start_quiz
  end

  def start_quiz
    puts "Ready to learn? What deck do you want to use?"
    filename = gets.chomp
    @new_deck = Deck.new(filename = "flashcard_samples.csv")#remember to delete this at the end!
    puts "Great, lets start, type exit when you are ready to end"
    play
  end

  def create_random_card
   array_of_cards = []
   @new_deck.deck.each {|x| array_of_cards << x}
   @random_card = array_of_cards.sample
  end

  def questions
    create_random_card
    puts @random_card.definition
  end

  def guess
    @guess = gets.chomp
    if @guess == @random_card.word
      puts "Good Guess!"
      play
      elsif @guess == "exit"
      exit
    else
      puts "Incorrect guess againc"
      guess
    end

    #@guess == @random_card.word ? puts "Good guess" : puts "Guess again!"

  end

  def play
    questions
    guess
  end
end


game = Quiz.new
