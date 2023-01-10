#for any code you think that might error out when executed...
begin 
num = 10/0
rescue
    puts "division by zero error"
end

tester = [1,2,3]
#you can also handle specific errors
begin
    tester["dog"]
    #num = 10/0
rescue ZeroDivisionError
    puts "Division Error"
end

#in this case...
    begin
        tester["dog"]
        #num = 10/0
    rescue ZeroDivisionError
        puts "Division Error"
    rescue TypeError 

    end
    #you can also store the error in a variable and print it to the user...
    begin
        tester["dog"]
        #num = 10/0
    rescue ZeroDivisionError => e
        puts e
    end