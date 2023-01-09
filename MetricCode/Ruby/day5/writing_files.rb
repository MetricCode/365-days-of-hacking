#append mode, add info into the file at the end...
File.open("test.txt","a") do |file|
    file.write("\n I am rock!")
end


#writing to the file...
#we can even create a new file...
#it will overwrite
File.open("test.txt","w") do |file|
    file.write("\n I am rock!")
end

#read and write mode...
File.open("test.txt","r+") do |file|
    #this pushes the cursor to the next line...
    file.readline()

    #this write command will write the second line of the file...
    file.write("\n I am rock!")
    file.readline()
end