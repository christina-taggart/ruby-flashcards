# Main file for

class Card
  attr_reader :question, :answer

  def initialize(question, answer)
    @question = question
    @answer = answer
    @correct = false
  end

  def to_s
    "{@question}"
  end
end


class Deck

  def initialize
    @flashcards << generate_cards_from_csv
  end

end


class UI

  def initialize(card)
    @card = card
  end

  def play
    puts "Welcome to Ruby Flash Cards. To play, just enter the correct term for each definition. Ready? Go!"
    puts @card.question
    input = gets.chomp
    if input == @card.answer
      puts "That was correct!"
    elsif input == 'exit'

    else
      puts "Incorrect!"
    end
  end

end


class Start_game

end


class Controller

  def initialize
    #make cards?
  end

  def generate_cards_from_csv
    CSV.foreach("flashcard_samples.txt") do |card|
      card = Card.new
      @flashcards << card.to_s
    end
  end

  def write_cards_to_csv
    CSV.open("flashcard_samples.txt", "w") do |csv|
      @flashcards.each do |card|
        csv << card.to_s
      end
    end
  end

end

game = UI.new(Card.new("What is 1 + 2 ?", "3"))
game.play



