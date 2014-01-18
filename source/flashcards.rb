require 'colorize'


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

module CardFactory
  def self.create_card(flashcard_data) # ["Software company in Seattle", "Microsoft"]
    Card.new(flashcard_data[0], flashcard_data[1])
  end
  def self.generate_cards(card_info) # this is a 2D array
    card_info.map! do |card|
      create_card(card)
    end
    # card_info # this is now an array of card objects
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
  # def shuffle!
  #   @cards.shuffle
  # end
end

class Quiz
  def initialize(deck)
    @deck = deck
  end
  def quiz!
    display_instructions
    @deck.cards.shuffle.each { |card| prompt_user(card) }
    display_results
  end
  def display_instructions
    puts ""
    puts "Welcome to Flash Cards!".light_blue
    puts "Answer each question with your best educated guess.".light_blue
    puts "Enter 'skip' to skip a question.".light_blue
    puts "Enter 'exit' to end the quiz.".light_blue
    puts ""
  end
  def display_results
    correct_or_not
    display_correct_or_not
  end

  def prompt_user(card)
    puts ""
    print "\t"
    puts "Definition:  ".blue
    print "\t"
    print card
    print "\t"
    print "Educated Guess: ".blue
    answer = gets.chomp!
    check_answer(answer, card)
  end
  def check_answer(answer, card)
    if answer == card.concept
      print "\t"
      puts "You are correct".green
      card.correct = true
    elsif answer == "skip"
      return
    elsif answer == "exit"
      display_results
      abort("Great Job!".yellow)
    else
      print "\t"
      puts "Try again please!".red
      prompt_user(card)
    end
  end
  def correct_or_not
    @correct_cards = @deck.cards.select {|card| card.correct}
    @incorrect_cards = @deck.cards.select{|card| !card.correct}
  end
  def display_correct_or_not
    puts ""
    puts "You know these really well: ".yellow
    @correct_cards.each {|card| puts "\t#{card}"}
    puts "You should review these:".yellow
    @incorrect_cards.each {|card| puts "\t#{card}"}
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

flash_cards = Pre_Game.set_up_game("flashcard_samples.txt")
game = Quiz.new(flash_cards)
game.quiz!