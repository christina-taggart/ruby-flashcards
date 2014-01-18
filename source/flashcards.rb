require 'csv'

# Models

class Card
  attr_accessor :definition, :word
  def initialize(card_data)
    @card_data = card_data
    @definition = card_data[:definition]
    @word = card_data[:word]
  end
end

class Deck
  attr_accessor :deck
  def initialize(deck_data)
    @deck = []
    @deck_data = deck_data
    populate_deck
  end

  def populate_deck
    @deck_data.map { |card_data| Card.new(card_data)}
  end

end

class Model_data
  attr_accessor :deck_data
  def initialize(file="flashcard_samples.csv")
    file.empty?
    # @file = file
    p file
    @deck_data = []
        # CSV.read(@file).each do |row|
        #  @deck_data << {word: row[0], definition: row[1]}
        #   end
        CSV.foreach(@file) do |row|
          p row
        end
          puts "this is what deck data looks like"
          p @deck_data
        end
end
#CONTROLLERS
class Quiz
  def initialize
    @current_game = View.new
    start_quiz
  end

  def start_quiz
    @current_game.prompt_for_deck
    filename = STDIN.gets.chomp
    @current_file = Model_data.new(filename)
    @new_deck = Deck.new(@deck_data)
    @current_game.exit_instructions
    @current_game.play
  end

  def shuffle_deck
    shuffled = @new_deck.deck.shuffle!
  end

  def get_a_card
    current_card = shuffled.pop
  end

  def card_word
    current_card.word
  end

  def card_definition
    current_card.definition
  end

  def make_a_guess
      guess = gets.chomp
      exit if guess == "exit"
    end

  def check_guess
    guess == card_word ? correct : incorrect
  end

end



class View

  def play
    puts card_definition
    make_a_guess
    check_guess
  end

  def correct
    puts "You got it right!"
    play
  end

  def incorrect
    puts "Sorry, guess again!"
    make_a_guess
  end

  def prompt_for_deck
    puts "Ready to learn? What deck do you want to use?"
  end

  def exit_instructions
     puts "Great, lets start, type exit when you are ready to end"
  end
end



#   class Play
#     def initialize
#     end
#   end

#   def play
#     shuffle_deck
#     questions
#     check_guess
#   end
# end

# View


game = Quiz.new