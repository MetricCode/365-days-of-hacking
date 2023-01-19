class Question
    attr_accessor :prompt, :answer
    def initialize(prompt,answer)
        @prompt = prompt
        @answer = answer
    end
end

q1 = "Who is M3tr1c's favourite youtuber? \n(a) Hackersploit \n(b) John Hammond "
q2 = "What is M3tr1c's specialization? \n (a) Forensics \n (b) Web Exploit"

questions = [
    Question.new(q1,"b"),
    Question.new(q2,"a")
]

def run_test(questions)
    answer = ""
    score = 0
    for x in questions
        puts x.prompt
        answer = gets.chomp()
        if answer == x.answer
            score += 1
        end
    end
    puts "Your scored " + score.to_s + " out of 2 :)"

end

run_test(questions)