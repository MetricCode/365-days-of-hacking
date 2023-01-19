class Coder
    def make_python_coder
        puts "We are good at python"
    end
    
    def make_java_coder
        puts "WE know Java!"
    end
end





meeee = Coder.new()
meeee.make_java_coder
# Inheritance is whereby we can borrow characteristics from another class, (Super class)
# we have inherited all functionalities...

# this is considered a sub class....
class New_Coder < Coder

    # if you dont want to inherit a method, you can ovewrite it ...
    def make_java_coder
        puts "Im the best at making java code..."
    end
    # you can also add some other functions...
end
me = New_Coder.new()
me.make_java_coder