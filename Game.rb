require 'json'
require_relative 'Player'

class Game
  MAX_GUESSES = 6
  DICTIONARY = File.readlines('words.txt').map(&:chomp).select { |word| word.length.between?(5, 12) }

  def initialize
    @player = Player.new
    @player.select_name
    @word = ""
    @guessed_letters = []
    @num_of_guesses = 0
    @guess = ""
    @temp_word = []
  end

  def play
    puts "Welcome, #{@player.name}! Let's play Hangman!"
    puts "Would you like to load a saved game? (y/n)"
    load_choice = gets.chomp.downcase
    if load_choice == 'y'
      if File.exist?('saves/saved_game.json')
        load_game
      else 
        puts "No saved game found. Starting a new game."
        @word = DICTIONARY.sample.chars
        @temp_word = Array.new(@word.length, "_")
      end 
    else
      puts "Starting a new game."
      @word = DICTIONARY.sample.chars
      @temp_word = Array.new(@word.length, "_")
    end
    
    while @num_of_guesses < MAX_GUESSES && @temp_word.include?("_")
      puts "Word: #{@temp_word.join(" ")}"
      puts "Guessed letters: #{@guessed_letters.join(", ")}"
      puts "You have #{MAX_GUESSES - @num_of_guesses} guesses left."
      puts "Do you want to save the game? (y/n)"
      save_choice = gets.chomp.downcase
      if save_choice == 'y'
        save_game
        puts "Do you want to continue playing? (y/n)"
        continue_choice = gets.chomp.downcase
        break if continue_choice == 'n'
      end
      puts "Enter a letter:"
      @guess = gets.chomp.downcase
      if @guess.length != 1 || !@guess.match?(/[a-z]/)
        puts "Please enter a single letter."
        next
      elsif @guessed_letters.include?(@guess)
        puts "You already guessed that letter."
        next
      else
        if @word.include?(@guess)
          puts "Good guess!"
          @word.each_with_index do |letter, index|
            @temp_word[index] = letter if letter == @guess
          end
        else
          puts "Sorry, that letter is not in the word."
          @guessed_letters << @guess
          @num_of_guesses += 1
        end
      end
      check_status(@temp_word, @word, @num_of_guesses)
    end
  end

  def check_status(temp_word, word, num_of_guesses)
    if temp_word == word
      puts "Congratulations, #{@player.name}! You guessed the word: #{word.join("")}!"
    elsif num_of_guesses >= MAX_GUESSES
      puts "Sorry, you've run out of guesses. The word was: #{word.join("")}."
    end
  end

  def save_game
    game_data = {
      player_name: @player.name,
      word: @word,
      guessed_letters: @guessed_letters,
      num_of_guesses: @num_of_guesses,
      temp_word: @temp_word
    }
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open('saves/saved_game.json', 'w') { |file| file.write(JSON.generate(game_data)) }
    puts "Game saved successfully."
  end

  def load_game
    if File.exist?('saves/saved_game.json')
      game_data = JSON.parse(File.read('saves/saved_game.json'))
      @player.name = game_data['player_name']
      @word = game_data['word']
      @guessed_letters = game_data['guessed_letters']
      @num_of_guesses = game_data['num_of_guesses']
      @temp_word = game_data['temp_word']
      puts "Game loaded successfully. Welcome back, #{@player.name}!"
    else
      puts "No saved game found."
    end
  end

end

Game.new.play