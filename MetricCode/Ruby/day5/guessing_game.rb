secret_word = "giraffe"
guess = ""

puts "Enter your guess"
guess_count = 0
guess_limit = 3
out_of_guesses = false

while guess != secret_word
    if guess_count< guess_limit and !out_of_guesses
        puts "Enter guess:"
        guess = gets.chomp()
        guess_count += 1
   else
    #puts "Your out of guesses"
    #break
    out_of_guesses = true
   end
end

puts "Nice! You won!"