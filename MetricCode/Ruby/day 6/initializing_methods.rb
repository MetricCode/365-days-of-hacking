# #classes have various attributes...
class Book
    #all books have title, author, pages...
    attr_accessor :title, :author, :pages
    def initialize(title,author, pages)
        @title = title
        @author = author
        @pages = pages
        # the "@title" is refering to the title in the class..
        # The "title" refers to the data entered by the user...
    end
end
#The initialize function will be called each time the .new() will be called...

#With the initialize function, we can pass our variables in the parenthisis..

book1 = Book.new("Half wild","Sally Green", 300)
puts book1.author