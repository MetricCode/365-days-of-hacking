def power(base_number,power_number)
   result = 1
   # for loop ...
   power_number.times do 
    result = result* base_number
   end
   return result 
end

puts power(2,3)