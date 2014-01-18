require 'yaml'
require 'ruby_cowsay'

class Card
  attr_reader :question, :answer
  def initialize(question, answer)
    @question = question
    @answer = answer
  end
end

class Deck
  def initialize(object)
    @deck = object
    shuffle!
  end

  def shuffle!
    @deck.shuffle!
  end

  def top_card
    top_card = @deck.first
    @deck.rotate!
    top_card
  end

  def score
  end
end

class Game
  def initialize
    @flashcards_hash = Yamler.new
    @correct_answers = 0
    @incorrect_answers = 0
    make_deck
    start_game
  end

  def make_deck
    card_holder = @flashcards_hash.yaml_hash.map { |question, answer| Card.new(question, answer) }
    @deck = Deck.new(card_holder)
  end

  def shuffle!
    @deck.shuffle!
  end

  def start_game
    @console = Console_UI.new
    @console.get_number_of_cards.times do play_game end
    tally_score
  end

  def play_game
    card = @deck.top_card
    @user_answer = @console.display_top_card(card.question)
    check_answer(card) ? congratulate : admonish(card)
  end

  def congratulate
    @correct_answers += 1
    @console.print_response("Congratulations! That's right!")
  end

  def admonish(card)
    @incorrect_answers += 1
    @console.print_response("WRONG! The answer is #{card.answer.upcase}!")#, {:cow => 'vader-koala'})
  end

  def tally_score
    @console.print_response("You got #{@correct_answers} right and #{@incorrect_answers} wrong.")
  end

  def check_answer(card)
    @user_answer.downcase == card.answer.downcase
  end
end

class Console_UI
  def get_number_of_cards
    puts "please enter how many cards you would like to play (1-10)"
    @number = gets.chomp.to_i
  end

  def display_top_card(question)
    puts question
    get_answer(question)
  end

  def print_response(response, sayer=Cow, args={:cow => 'dragon'} )
    if sayer
      puts sayer.new(args).say response
    else
      puts response
    end
  end

  def get_answer(question)
    guess = gets.chomp
  end
end

class Yamler
  attr_reader :yaml_hash
  def initialize
    get_yaml
  end

  def get_yaml
    @yaml_hash = Hash[YAML.load_file('yamallamadingdong.yml')]
  end

  def give_yaml
  end
end


# game = Game.new
Game.new


# read_yaml = YAML.load_file('yamallamadingdong.yml')


