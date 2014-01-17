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
  def self.quiz(csv_file, quiz_type)
    deck = DeckBuilder.csv_to_deck(csv_file)
    card_mode = :top_card if quiz_type == "ordered"
    card_mode = :random_card if quiz_type == "random"
    deck.length.times do
      test_card(deck.send(card_mode))
    end
  end

  private

  def self.test_card(card)
    attempts = 0
    guess = String.new
    while attempts <= 3
      puts "FRONT:"
      puts "#{card.front}\n"
      puts "Enter guess (or 'SKIP'):"
      guess = gets.chomp
      break if guess == card.back || guess == "SKIP"
      attempts += 1
    end
  end
end

#-----DRIVERS-----
# test_deck = DeckBuilder.csv_to_deck("ruby_deck.csv")
# 5.times { p test_deck.top_card }


#-----ARGVifying FLASHCARDS-----
csv_file = ARGV[0]
quiz_type = ARGV[1]
FlashCards.quiz(csv_file, quiz_type)