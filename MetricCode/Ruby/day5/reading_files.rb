#for this to work, the file is in the same directory as the file

#You can also set a variable as the file...
file = File.open("test.txt","r")
#after working the file, remember to close it to prevent memory from being overloaded
file.close()



File.open("test.txt","r") do |file|

    #reading the file...
    puts file.read()
    #read the firstline
    puts file.readline()
    #this will read the next line...
    puts file.readline()

    #will read all the lines in the file...
    puts file.readlines()

    #will read the first character of the lines
    puts file.readchar()

    for line in file.readlines()
        puts line
        #will print all the lines...
    end

# end simplifies that we're done with the file...
end

