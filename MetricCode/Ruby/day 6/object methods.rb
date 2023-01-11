# instance methods...
class Student
    attr_accessor :name, :major ,:grade
    def initialize(name,major,grade)
        @name = name
        @major = major
        @grade = grade
    end
    def has_honors
        if @grade >= 3.5
            return true
        else
            return false
        end
    end    

end
student1 = Student.new("Jim","Computer Science",3.6)
student2 = Student.new("Andrew","Arts",2.6)

puts student1.has_honors
puts student2.has_honors