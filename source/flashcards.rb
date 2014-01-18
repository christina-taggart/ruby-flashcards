# Main file for flashcards
require 'paint'

class View
  def initialize
    welcome_message
  end

  def welcome_message
    puts <<-eos
      Welcome to the negative Nancy flashcard game. Play. Or don't. I don't care.
      To quit, type: 'I am worthless'
      ---------------------------------
    eos
  end

  def user_input
    @input = gets.chomp!
  end

  def print_definition(card)
    puts card.definition
    user_input
  end

  def print_term(card)
    puts card.term
  end

  def print_report(metrics)
    puts "\nFinal Score Report\n"
    puts "Number Correct: " + Paint[ metrics[:number_solved], :green]
    puts "Number Incorrect: " + Paint[ metrics[:number_unsolved], :red]
  end
end

class Controller
  def initialize
    @view = View.new  # initiates view
    @model = Model.new # initiates model and pulls in data
    run_game
  end

  def run_game
    while number_unsolved > 0
      @current_card = top_card
      @current_answer = @view.print_definition(@current_card)
      break if @current_answer == "I am worthless"
      validate_answer
    end
    @view.print_report({number_solved: number_solved, number_unsolved: number_unsolved})
  end

  def validate_answer
    if @current_answer == @current_card.term
      puts "correct!"
      deck.card_correct!
    else
      puts "incorrect!"
      deck.card_incorrect!
    end
  end

  def check_response
    @model.check_definition
  end

  def deck
    @model.deck
  end

  def top_card
    deck.unsolved.first
  end

  def number_solved
    deck.solved.length
  end

  def number_unsolved
    deck.unsolved.length
  end

end

class Model
  attr_reader :data_from_file, :deck, :game
  def initialize(source_file = 'flashcard_samples.txt')
    @source_file = source_file
    @data_from_file = []
    import_from_txt
    @deck = Deck.new(@data_from_file)
    # @game = Game.new(@deck)
  end

  private

    def import_from_txt
      File.open(@source_file, 'r') do |file|
        @current_hash = {}
        file.each_line {|line| populate_data_from_file(line) }
      end
    end

    def populate_data_from_file(line)
      if $. % 3 == 1
        @current_hash[:definition] = line.chomp
      elsif $. % 3 == 2
        @current_hash[:term] = line.chomp
        @data_from_file << @current_hash
        @current_hash = {}
      end
    end
end

class Card
  attr_reader :definition, :term
  def initialize(card_data)
    @definition = card_data[:definition]
    @term = card_data[:term]
  end
end

class Deck
  attr_reader :unsolved, :solved
  def initialize(deck_data)
    @deck_data = deck_data
    @unsolved = []
    @solved = []
    create_cards
  end

  def create_cards
    @deck_data.map do |card|
      @unsolved << Card.new(card)
    end
    @unsolved.shuffle!
  end

  def top_card
    @unsolved.first
  end

  def card_correct!
    @solved << @unsolved.shift
  end

  def card_incorrect!
    @unsolved.rotate!
  end
end

# class Game
#   def initialize(deck)
#     @deck = deck
#   end

#   def number_solved
#     @deck.solved.length
#   end

#   def number_unsolved
#     @deck.unsolved.length
#   end
# end

# model = Model.new
# deck = Deck.new(model.data_from_file)
# puts deck.unsolved

Controller.new
