#classes have various attributes...
class Book
    #all books have title, author, pages...
    attr_accessor :title, :author, :pages
end


#creating objects...
book1 = Book.new()
book1.title = "Half Wild"
book1.author = "Sally Green"
book1.pages = "300"


puts book1.title
