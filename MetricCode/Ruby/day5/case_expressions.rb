def get_day_name(day)
  day_name = ""
  
    # if day=="mon"
    #     day_name=="Monday"
    # elsif day =="tue"
    #     day_name =="Tuesday"

    # case best used when comapring if to one value against different values...
    case day
    when "mon"
        day_name="Monday"
    when "tue"
        day_name = "Tuesday"
    when "wed"
        day_name = "Wednesday"
    when "thu"
        day_name = "Thursday"
    when "fri"
        day_name = "Friday"
    when "sat"
        day_name = "Saturday"
    when "sun"
        day_name = "Sunday"
    else 
        day_name = "Invalid Abreviation!"
    end    


  return day_name
    
end

puts get_day_name("sat")