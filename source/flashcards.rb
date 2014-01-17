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

module DeckHelpers
  def get_flashcards_from_file
    deck_data = File.read("flashcard_samples.txt").split("\n")
    deck_data.delete("")
    deck_data
  end

  def change_deck_data_to_flashcards(deck_data)
    test = []
    until deck_data.empty?
      test << FlashCards.new(deck_data.slice!(0), deck_data.slice!(0))
    end
    p test
  end
end


class Deck
  include DeckHelpers
  def initialize
    @deck = []
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

end
 #prompts usr with game explanation
 #shows 1 side of top card, allows for usr reponse, displays if correct or not.
 #if correct, congratulate and move to next card
 #if incorrect, say incorrect and ask usr to guess again until correct.
 #when correct, advance to next card.
 #if no more cards, congratulate and quit.
 ###CONTROLLER
class Interface
  def initialize(deck)
    @current_card = deck.grab_top_card
  end

  def greeting
    puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition.  Ready?  Go!"
  end

  def show_top_card
    puts "Definition:"
    puts "current card testing: "
    p @current_card
    @current_card.definition
  end

  def prompt_guess
    puts "Guess: "
    @guess = gets.chomp
  end

  def check_guess
    @guess.eql?(@current_card.term) ? "Correct!" : "Wrong!"
  end

  def test_knowledge
    prompt_guess
    puts check_guess
  end
end

# Driver Code
flashcard_1 = FlashCards.new("What day is today?", "Friday")
p flashcard_1

this_deck = Deck.new
p this_deck

this_deck.add_card(flashcard_1)
p this_deck

this_deck.remove_card(flashcard_1)
p this_deck

flashcard_2 = FlashCards.new("Where are we?", "Dev Bootcamp")
this_deck.add_card(flashcard_2)
flashcard_3 = FlashCards.new("What do we do?", "Code!!!!")
this_deck.add_card(flashcard_3)
p this_deck
this_deck.shuffle_deck!
p this_deck

my_game = Interface.new(this_deck)
my_game.greeting
p my_game.show_top_card
# my_game.test_knowledge
deck_data = this_deck.get_flashcards_from_file
this_deck.change_deck_data_to_flashcards(deck_data)


# <Deck:0x007f984985e100 @deck=[#<FlashCards:0x007f984985de80 @definition="What do we do?", @term="Code!!!!">, #<FlashCards:0x007f984985def8 @definition="Where are we?", @term="Dev Bootcamp">]>
