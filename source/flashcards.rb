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

  def check_answer(user_input)
    user_input == @term
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

class Console
  def initialize
  end

  def greeting
    puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition.  Ready?  Go!"
  end

  def display_top_card(current_flashcard)
    print "\nDefinition: "
    puts "\n#{current_flashcard.definition}\n"
  end

  def prompt_guess
     print "Guess: "
  end

  def display_guessed_correctly
    puts "Correct!"
  end

  def display_guessed_wrong
    puts "Wrong!"
  end

  def display_removed_card_message
    "Card was removed from deck!"
  end

  def display_cards_remaining(deck)
    puts "#{deck.count} cards remaning in this deck."
  end
end

class Quizzer
  attr_accessor :guessed_correctly
  def initialize
  end

  def accept_guess
     @guess = gets.chomp
  end

  def check_guess(top_card)
    if @guess.eql?(top_card.term)
      @guessed_correctly = true
    else
      @guessed_correctly = false
    end
  end

end

class Launcher
  def initialize
    @deck = Deck.new
    @console = Console.new
    @quiz = Quizzer.new
  end

  def run
    @console.greeting
    until @deck.empty?
      show_card_to_user
      reset_guess
      check_guesses
      remove_card
    end
  end

  def remove_card
    @deck.remove_card(@deck.grab_top_card)
    @console.display_removed_card_message
    @console.display_cards_remaining(@deck)
  end

  def check_guesses
    until @quiz.guessed_correctly.eql?(true)
      @console.prompt_guess
      @quiz.accept_guess
      @quiz.check_guess(@deck.grab_top_card) ? @console.display_guessed_correctly : @console.display_guessed_wrong #displays correct or wrong depending on the guess
    end
  end

  def check_guess_with_card
    # REVIEW this dosent actually work but you get what I mean
    card.check_answer(user_input)
  end

  def show_card_to_user
    @console.display_top_card(@deck.grab_top_card)
  end

  def reset_guess
    @quiz.guessed_correctly = false
  end
end

# DRIVER CODE
Launcher.new.run

