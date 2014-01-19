require 'colorize'

#-----MODEL-----

module CardFactory
  def self.create_card(flashcard_data)
    Card.new(flashcard_data[0], flashcard_data[1])
  end
  def self.generate_cards(card_info) # this is a 2D array
    card_info.map! do |card|
      create_card(card)
    end
  end
end

class Card
  attr_reader :definition , :concept
  attr_accessor :correct
  def initialize(definition, concept, correct=false)
    @definition = definition
    @concept = concept
    @correct
  end
  def to_s
    "#{@definition}".word_wrap(100)
  end
end

class Deck
  attr_reader :cards
  def initialize(cards)
    @cards = cards #this is an array of card objects
  end
end


#-----CONTROLLER-----

class Quiz
  def initialize(deck)
    @deck = deck
  end
  def quiz!
    Viewer.display_instructions
    @deck.cards.shuffle.each { |card| prompt_user(card) }
    Viewer.display_results
  end

  def prompt_user(card)
    Viewer.display_prompt(card)
    answer = gets.chomp!
    check_answer(answer, card)
  end

  def check_answer(answer, card)
    if answer == card.concept
      Viewer.display_correct
      card.correct = true
    elsif answer == "skip"
      return
    elsif answer == "exit"
      correct_or_not
      Viewer.display_results(@correct_cards, @incorrect_cards)
      abort("Great Job!".yellow)
    else
      Viewer.try_again
      prompt_user(card)
    end
  end

  def correct_or_not
    @correct_cards = @deck.cards.select {|card| card.correct}
    @incorrect_cards = @deck.cards.select{|card| !card.correct}
  end
end


#-----VIEWER-----

class Viewer
  def self.display_instructions
    puts ""
    puts "Welcome to Flash Cards!".light_blue
    puts "Answer each question with your best educated guess.".light_blue
    puts "Enter 'skip' to skip a question.".light_blue
    puts "Enter 'exit' to end the quiz.".light_blue
    puts ""
  end

  def self.display_results(correct_cards, incorrect_cards)
    puts ""
    puts "You know these really well: ".yellow
    correct_cards.each {|card| puts "\t#{card}"}
    puts "You should review these:".yellow
    incorrect_cards.each {|card| puts "\t#{card}"}
  end

  def self.display_prompt(card)
    puts ""
    print "\t"
    puts "Definition:  ".blue
    print "\t"
    print card
    print "\t"
    print "Educated Guess: ".blue
  end

  def self.display_correct
    print "\t"
    puts "You are correct".green
  end

  def self.try_again
    print "\t"
    puts "Try again please!".red
  end
end


#-----HELPERS-----

class Pre_Game
  def self.set_up_game(source_file) # specify where you're getting your card data
    card_info = Pre_Game.format_txt_file(source_file) # format the cards
    card_objects = CardFactory.generate_cards(card_info) # turn cards into objects
    Deck.new(card_objects) # create new deck with these card objects
  end
  def self.format_txt_file(source_file)
    card_content_array = []
    File.readlines(source_file).each_slice(3) do |s|
      card_content_array << [s[0].strip, s[1].strip]
    end
    card_content_array
  end
end


class String
  def word_wrap n
    words = self.split ' '
    str = words.shift
    words.each do |word|
      connection = (str.size - str.rindex("\n").to_i + word.size > n) ? "\n\t" : " "
      str += connection + word
    end
    "#{str} \n\n"
  end
end


#----------

flash_cards = Pre_Game.set_up_game("flashcard_samples.txt")
game = Quiz.new(flash_cards)
game.quiz!