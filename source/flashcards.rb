module DeckHelpers
  def get_flashcards_from_file
    deck_data = File.read("flashcard_samples.txt").split("\n")
    deck_data.delete("")
    deck_data
  end

  def change_deck_data_to_flashcards(deck_data)
    deck = []
    until deck_data.empty?
      deck << FlashCards.new(deck_data.slice!(0), deck_data.slice!(0))
    end
    deck
  end
end

###MODELS
class FlashCards
  def initialize(definition, term)
    @definition = definition
    @term = term
  end

  def definition
    @definition
  end

  def term
    @term
  end
end

class Deck
  include DeckHelpers
  def initialize
    @deck = change_deck_data_to_flashcards(get_flashcards_from_file)
  end

  def add_card(flashcard)
    @deck << flashcard
  end

  def remove_card(flashcard)
    @deck.delete(flashcard)
  end

  def shuffle_deck!
    @deck.shuffle!
  end

  def grab_top_card
    @deck.last
  end

  def empty?
    @deck.empty? ? true : false
  end

  def count
    @deck.count
  end
end

# TODO: This will become the view at some point....
class Interface
  def initialize(deck)
    @deck = deck
  end

  def greeting
    puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition.  Ready?  Go!"
  end

  def show_top_card
    @current_card = @deck.grab_top_card
    print "\nDefinition: "
    puts "\n#{@current_card.definition}\n"
  end

  def prompt_guess
    print "Guess: "
    @guess = gets.chomp
  end

  def check_guess
    if @guess.eql?(@current_card.term)
      @guessed_correctly = true
      puts "Correct!"
    else
      @guessed_correctly = false
      puts "Wrong!"
    end
  end

  def test_knowledge
    until @deck.empty?
      show_top_card
      @guessed_correctly = false
      until @guessed_correctly.eql?(true)
        prompt_guess
        check_guess
      end
      @deck.remove_card(@deck.grab_top_card)
      puts "Card was removed from deck!"
      puts @deck.count
    end
  end
end

# DRIVER CODE

this_deck = Deck.new
my_game = Interface.new(this_deck)
my_game.greeting
my_game.test_knowledge