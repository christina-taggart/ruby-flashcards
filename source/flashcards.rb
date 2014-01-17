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

###MODEL
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
    @current_card = @deck.grab_top_card
  end

  def greeting
    puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition.  Ready?  Go!"
  end

  def show_top_card
    puts "Definition:"
    puts @current_card.definition
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
    until @guessed_correctly.eql?(true)
      prompt_guess
      check_guess
    end
    @deck.remove_card(@deck.grab_top_card)
    puts "Card was removed from deck!"
    puts @deck.count
  end
end

# class Controller
#   def initialize
#     @deck = Deck.new
#     @game_interface = Interface.new
#   end

#   def run
#     @game_interface.greeting
#     until @deck.empty?
#       @game_interface.show_top_card
#       @game_interface.test_knowledge
#     end
#   end
# end
# Driver Code
# flashcard_1 = FlashCards.new("What day is today?", "Friday")
# p flashcard_1


# p this_deck

# this_deck.add_card(flashcard_1)
# p this_deck

# this_deck.remove_card(flashcard_1)
# p this_deck

# flashcard_2 = FlashCards.new("Where are we?", "Dev Bootcamp")
# this_deck.add_card(flashcard_2)
# flashcard_3 = FlashCards.new("What do we do?", "Code!!!!")
# this_deck.add_card(flashcard_3)
# p this_deck
# this_deck.shuffle_deck!
# p this_deck


# This was working... before controller!
this_deck = Deck.new
my_game = Interface.new(this_deck)
my_game.greeting
my_game.show_top_card
my_game.test_knowledge
# my_controller = Controller.new
# my_controller.run

# <Deck:0x007f984985e100 @deck=[#<FlashCards:0x007f984985de80 @definition="What do we do?", @term="Code!!!!">, #<FlashCards:0x007f984985def8 @definition="Where are we?", @term="Dev Bootcamp">]>
