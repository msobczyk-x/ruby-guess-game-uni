#config

require 'colorize'
game_state = true
randomNumber = rand(1..100)
guesses = 0
#game
while game_state
    puts "Guess a number between 1 and 100".colorize(:yellow)
    guess = gets.chomp
    guessNumber = Integer(guess) rescue false
    if guessNumber == false
        if guess == "finish"
            puts "You have exited the game".colorize(:red)
            game_state = false
        end
    else
        guess = guess.to_i
        if guess == randomNumber
            puts "You win!".colorize(:green)
            game_state = false
        elsif guess > randomNumber
            puts "Too high!".colorize(:red)
            guesses += 1
        elsif guess < randomNumber
            puts "Too low!".colorize(:light_blue)
            guesses += 1
        end
    end
    end
