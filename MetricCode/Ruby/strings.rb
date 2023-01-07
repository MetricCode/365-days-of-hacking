#if you want to put a quotation mark in a string put a backslash before it..
puts "Metric\" code"
# print out a new line
puts "Let's \nRock!"

# using variables
tester = "I can do it!"
puts tester

# String Methods...
# text is in uppercase
puts tester.upcase()
#text is in lowecase
puts tester.downcase()
#Removes trailing white space...
testing = "    I am rock!     "
puts testing.strip()

# tell you the character length(includes white space)...
puts tester.length()

# to find a value in a string(Returns true if present and false if not present)...
puts tester.include? "do"

# printing index positions of strings 
phrase = "High Life"
puts phrase[0]

#print a range of characters...
puts phrase[0, 4] # this will print the first four characters...

# print out the index position of a value...
puts phrase.index("e")

# you dont have to put your string on variables...
puts "programming".upcase()
