#config
require 'colorize'
require 'io/console'
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
            puts "You guessed the number in #{guesses} guesses".colorize(:green)
            puts "Dou you want to play again? (y/n)".colorize(:yellow)
            answer = gets.chomp
            if answer == "y"
                randomNumber = rand(1..100)
                guesses = 0
                
                $stdout.clear_screen
            else
                puts "You have exited the game".colorize(:red)
                game_state = false
            end
        elsif guess > randomNumber
            puts "Too high!".colorize(:red)
            guesses += 1
        elsif guess < randomNumber
            puts "Too low!".colorize(:light_blue)
            guesses += 1
        end
    end
    end
