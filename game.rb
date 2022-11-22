require 'colorize'
require 'io/console'
require 'json'
require 'table_print'
#functions


Score = Struct.new(:name, :guesses, :date)

def scoreboardShow(scoreboard)
    if scoreboard != []
        puts "SCOREBOARD".colorize(:yellow)
        scoreboard.sort_by! { |score| score.guesses }
        tp scoreboard, :name, :guesses, :date
        
    end
    scoreboardSave(scoreboard)
    end


#show scoreboard
# def scoreboardShow(scoreboard)
#     #if scoreboard not empty, show scoreboard
#     if scoreboard != {}
    
#     #sorts the scoreboard by value
#         scoreboard = scoreboard.sort_by {|k, v| v}
#     #prints the scoreboard

#         puts "Scoreboard:".colorize(:green)
#         puts "Nickname  |   Score   |   Date ".colorize(:green)
#         scoreboard.each do |key, value|
#             puts "#{key}    |   #{value[0]}  |   #{value[1]}".colorize(:green)
#         end
#         scoreboardSave(scoreboard)
#     end
# end


#scoreboard add score
def scoreboardAdd(scoreboard, guesses)
    #adds the player to the scoreboard
    puts "Enter your name to save your score".colorize(:green)
    name = gets.chomp
    if checkIfYourScoreBeaten(scoreboard, guesses, name)
        puts "You've beaten your personal score !".colorize(:green)
    end
    if checkIfBestScoreBeaten(scoreboard, guesses)
        puts "You've beaten the best score !".colorize(:green)
    end
    scoreboard.append(Score.new(name, guesses, Time.now.strftime("%d/%m/%Y %H:%M")))
end

#end functions
def endGame(scoreboard)
    puts "You have exited the game".colorize(:red)
    scoreboardShow(scoreboard)
    puts "Thanks for playing!".colorize(:green)
    exit
end


#load scoreboard from file
def scoreboardLoad()
    if File.exist?("scoreboard.json") and File.size?("scoreboard.json") > 0
        file = File.read('scoreboard.json')
        return JSON.parse(file, object_class: Score)
    else
        return []
    end
end

#save scoreboard to file
def scoreboardSave(scoreboard)
    sb = []
    for i in 0..scoreboard.length-1
        sb[i] = scoreboard[i].to_h
    end
    File.write('scoreboard.json', JSON.dump(sb))
end

def checkIfYourScoreBeaten(scoreboard, guesses, name)
    if scoreboard.length == 0
        return false
    end
    for i in 0..scoreboard.length-1
        if guesses < scoreboard[i].guesses and scoreboard[i].name == name
            return true
        end
    end
    return false
end

def checkIfBestScoreBeaten(scoreboard, guesses)
    if scoreboard.length == 0
        return true
    end
    for i in 0..scoreboard.length-1
        if guesses < scoreboard[i].guesses
            return true
        end
    end
    return false
end

#config
game_state = true
randomNumber = rand(1..100)
guesses = 0
scoreboard = scoreboardLoad()

#main game loop
while game_state
    puts "Guess a number between 1 and 100".colorize(:yellow)
    guess = gets.chomp
    guessedNumber = Integer(guess) rescue false
    if guessedNumber == false
        if guess == "finish"
            endGame(scoreboard)
        end
    else
        guess = guess.to_i
        if guess == randomNumber
            guesses += 1
            puts "You win!".colorize(:green)
            puts "You guessed the number in #{guesses} guesses".colorize(:green)
            scoreboardAdd(scoreboard, guesses)

            puts "Do you want to play again? (y/n)".colorize(:yellow)
            answer = gets.chomp
            if answer == "y"
                randomNumber = rand(1..100)
                guesses = 0
                $stdout.clear_screen
            else
                endGame(scoreboard)
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
