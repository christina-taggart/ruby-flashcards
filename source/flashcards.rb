require 'csv'

class Game
  def initialize
    @score = 0
    @deck = Deck.new("flashcard_samples.csv").all_cards
    play_game
  end

  def play_game
    counter = 1
    until @deck.length == counter
      @deck = @deck.shuffle
      @deck.each do |flashcard|
        ask_question(flashcard)
        counter += 1
      end
    end
  end

  def ask_question(flashcard)
    number_of_attempts = 3
    new_award = AwardPoints.new(flashcard)
    new_award.ask_question
    user_answer = gets.chomp

    while number_of_attempts > 0
      if user_answer.downcase == flashcard.answer.downcase
        new_award.correct
        number_of_attempts = 0
      elsif user_answer == "exit"
        new_award.exit
      elsif user_answer == "score"
        new_award.score
        user_answer = gets.chomp
      elsif user_answer.downcase != flashcard.answer.downcase
        number_of_attempts -= 1
        puts "You got the answer wrong. You have #{number_of_attempts} more attempts."
        if number_of_attempts > 0
          puts flashcard.question
          user_answer = gets.chomp
        else
          puts "Sorry, you got it wrong and are out of attempts. No points for you. The correct answer is '#{flashcard.answer}'"
        end
      end
    end
  end
end

class Deck
  attr_reader :all_cards
  def initialize(file)
    @file = file
    @all_cards = []
    create_all_cards_array
  end

  def create_all_cards_array
    CSV.foreach(@file) do |csv| #foreach gets every row
      @all_cards << Card.new(csv[0], csv[1], csv[2])
    end
  end
end

class AwardPoints
  def initialize(flashcard)
    @flashcard = flashcard
    @score = 0
    @number_of_attempts = 3
  end

  def ask_question
    show_intro #REVIEW separation of concerns
    puts @flashcard
  end

  def show_intro
    puts ""
    puts "Here is your question. Type \"exit\" to stop playing at anytime or \"score\" to view your current score ."
    puts "---------"
  end

  def correct
    case
      when @flashcard.difficulty == "easy"
        points_for_turn = 1
        @score += points_for_turn
      when @flashcard.difficulty == "medium"
        points_for_turn = 3
        @score += points_for_turn
      when @flashcard.difficulty == "hard"
        points_for_turn = 5
        @score += points_for_turn
      else
        puts "ERROR"
    end
    puts "Congrats, you got it right and earned #{points_for_turn} points. Your total score is #{@score}"
  end

  def exit
    abort("Thanks for playing.")
  end

  def score
    puts "You currently have #{@score} points. Great Job!"
    puts @flashcard
  end
end

class Card
  attr_reader :question, :answer, :difficulty
  def initialize(question, answer, difficulty)
    @question = question
    @answer = answer
    @difficulty = difficulty
  end

  def to_s
    self.question
  end
end

# Game.new
card = Card.new('This is a question!', 'answer', '3')
award_points = AwardPoints.new(card)

award_points.show_intro

award_points.ask_question

