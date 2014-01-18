require 'csv'

#-----DECK BUILDER MODULE-----

module DeckBuilder
  def self.csv_to_deck(csv_file)
    deck = Deck.new
    CSV.foreach(csv_file) do |row|
      deck.add_card(Card.from_array(row))
    end
    deck
  end
end


#-----CARD & DECK CLASSES (MODEL)-----

class Card
  attr_reader :front, :back

  def initialize(front, back = nil)
    @front = front
    @back = back
  end

  def self.from_array(array)
    self.new(array[0], array[1])
  end
end


class Deck
  def initialize(cards = [])
    @cards = cards
  end

  def add_card(card)
    @cards << card
  end

  def random_card
    @cards.sample
  end

  def top_card
    top = @cards.first
    @cards.rotate!
    top
  end

  def shuffle
    @cards.shuffle!
  end

  def length
    @cards.length
  end
end


#---FLASHCARDS QUIZZER (CONTROLLER)-----

class FlashCards
  @@correct_counter = 0
  @@card_counter = 0
  @@exit = false

  def self.quiz(deck_file, quiz_type = "ordered")
    deck = DeckBuilder.csv_to_deck(deck_file)
    reset_counters
    deck.shuffle if quiz_type == "random"
    deck.length.times do
      break if @@exit == true
      test_card(deck.top_card)
    end
    FlashCardsViewer.display_score(percent_correct)
  end

  private

  def self.test_card(card)
    attempts = 0
    guess = String.new
    while attempts < 3
      FlashCardsViewer.display_card(card)
      guess = gets.chomp
      case guess
      when card.back.downcase
        FlashCardsViewer.correct_guess
        increment_correct_counter
        increment_card_counter
        break
      when "SKIP"
        FlashCardsViewer.skip_card(card)
        increment_card_counter
        break
      when "EXIT"
        exit_quiz
        break
      else
        FlashCardsViewer.incorrect_guess(card, attempts)
        increment_card_counter
      end
      attempts += 1
    end
  end

  def self.exit_quiz
    @@exit = true
  end

  def self.percent_correct
    return 0 if @@card_counter == 0 && @@correct_counter == 0
    ((@@correct_counter.to_f / @@card_counter.to_f) * 100).floor
  end

  def self.increment_correct_counter
    @@correct_counter += 1
  end

  def self.increment_card_counter
    @@card_counter += 1
  end

  def self.reset_counters
    @@correct_counter = 0
    @@card_counter = 0
  end
end


#-----FLASHCARDSVIEWER (VIEWER)-----

class FlashCardsViewer
  def self.display_card(card)
    puts "\n#{card.front}"
    puts "Enter guess (or 'SKIP' or 'EXIT'):"
  end

  def self.display_score(percent_correct)
    puts "\nQUIZ COMPLETE!"
    puts "PERCENT CORRECT: #{percent_correct}%"
  end

  def self.correct_guess
    puts "\nCorrect!\n"
  end

  def self.incorrect_guess(card, attempts)
    puts "\nIncorrect guess! #{2-attempts} guesses left."
    if attempts == 2
      puts "The answer was: #{card.back}\n"
    end
  end

  def self.skip_card(card)
    puts "\nThe answer was: #{card.back}\n"
  end
end


#-----ARGVifying FLASHCARDS-----
file = ARGV.shift
quiz_type = ARGV.shift
FlashCards.quiz(file, quiz_type)