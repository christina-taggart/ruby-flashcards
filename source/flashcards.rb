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


#-----CARD & DECK CLASSES-----

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
    @cards.shift
    @cards.push(top)
    top
  end

  def shuffle
    @cards.shuffle!
  end

  def length
    @cards.length
  end
end


#---FLASHCARDS - CLI FLASHCARD VIEWER-----

class FlashCards
  def self.quiz(deck_file, quiz_type = "ordered")
    deck = build_deck(deck_file)
    deck.shuffle if quiz_type == "random"
    deck.length.times do
      test_card(deck.top_card)
    end
  end

  private

  def self.test_card(card)
    attempts = 0
    guess = String.new
    while attempts < 3
      puts "\nFRONT:"
      puts "#{card.front}"
      puts "Enter guess (or 'SKIP'):"
      guess = gets.chomp
      if guess == card.back
        puts "\nCorrect!\n"
        break
      elsif guess == "SKIP"
        puts "\nThe answer was: #{card.back}\n"
        break
      end
      puts "\nIncorrect guess! #{2-attempts} guesses left."
      puts "The answer was: #{card.back}\n" if attempts == 2
      attempts += 1
    end
  end

  def self.build_deck(deck_file)
    if deck_file =~ (/\.csv/)
      DeckBuilder.csv_to_deck(deck_file)
    else
      raise "Invalid deck file."
    end
  end
end


#-----ARGVifying FLASHCARDS-----
file = ARGV.shift
quiz_type = ARGV.shift
FlashCards.quiz(file, quiz_type)