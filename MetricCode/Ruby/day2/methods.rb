# also known as functions

def sayhi
    puts "Metric Rocks!"
end

#sayhi

# you can specify a specific data in functions/methods
def testing(name,age, style="awesome")
    puts ("Hello " + name + ", you are " + age.to_s + " years old " + style)
end
testing("Metric",19)