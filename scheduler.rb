#Project Name: Assignment 1 Room Reservation Project 
#Description: This project will allow the user to reserve a room on campus for a specified duration of time. The user is prompted to enter some 
              #of the details about the room, and then the program will check if the room is available for the specified duration.
              #It will then print out the details of the available room on screen and generates a .csv file also.  
#Filename: scheduler.rb
#Description: This program organizes events by scheduling rooms based on their availability and features. It reads room and booking details from
              #csv files, then based on the user input it allocates rooms for different parts of the event. In the end it outputs a detailed 
              #schedule, by displayig it on screen and saving it to CSV file. 
#Last Modified: 3/1/24 

require 'csv'
require 'date'
require 'time'
require './rooms_on_campus.rb'
require './reserved_rooms.rb'
require './file_writer.rb'

# Function  to get a valid filename input from the user
def get_input_filename(prompt_message)
    filename = ''
    # Initialize variable to keep track of file validity
    file_valid = false 
  
    until file_valid
      print prompt_message
      filename = gets.chomp
  
      if File.exist?(filename) && File.readable?(filename)
        # Update the condition variable when a valid file is provided
        file_valid = true 
      else
        puts "File does not exist or cannot be read. Please enter a valid filename."
      end
    end
    # Return the valid filename
    filename 
  end
  

# A function to read and store the rooms data on campus from the CSV file 
def read_rooms_on_campus(filename)
  #initialize an empty array to hold room objects
  rooms = []  
  File.open(filename, 'r') do |file|  
     # Skip the first line (header)
    file.readline 
    file.each_line.with_index(2) do |line, line_num|  
      fields = line.strip.split(',')
      #check if the line has correct number of fields (9 fields)
      if fields.length != 9 
        puts "Warning: Line #{line_num} is malformed and will be skipped: #{fields.inspect}"
        next
      end
      # Create a new RoomsOnCampus object with the fields and add it to the rooms array
      rooms << RoomsOnCampus.new(*fields) 
    end 
  end 
  #return the array of room objects 
  rooms 
end


# A function to read and store the reserved room data from the CSV file
def read_reserved_rooms(filename)
  #Initialize an empty array to store instances of ReservedRooms
  reserved_rooms = [] 
  File.open(filename, 'r') do |file|
    #skipping the first line of the CSV file
    file.readline 
    file.each_line do |line|
      fields = line.strip.split(',')
      reserved_rooms << ReservedRooms.new(*fields)
    end 
  end 
  # Return the array of ReservedRooms instances
  reserved_rooms 
end

#Function to write the scheduling plan to a CSV file 
def write_scheduling_plan(schedule, filename)
  #Create a new FileWriter object
  writer = FileWriter.new(filename) 
  # Writes a header row to the CSV file
  writer.write_line("Date,Time,Building,Room,Capacity,Computers,Seating,Seating Type,Food Allowed,Room Type,Priority,Purpose")

  # Iterates over each entry in the schedule array to write it to the CSV file
  schedule.each do |entry|
    #Write details of the current entry to the file 
    #Accesses various properties of the entry hash and the nested room object 
    writer.write(
      entry[:date], 
      entry[:time],
      entry[:room].building, 
      entry[:room].room, 
      entry[:room].capacity.to_s,
      entry[:room].computers ? 'Yes' : 'No', 
      entry[:room].seating, 
      entry[:room].seating_type,
      entry[:room].food_allowed ? 'Yes' : 'No', 
      entry[:room].room_type, 
      entry[:room].priority, 
      entry[:purpose]
    )
  end
  #Close the FileWriter object to ensure data is saved and the file is properly closed 
  writer.close
end

# Function to print the scheduling plan to screen 
def print_scheduling_plan_on_screen(schedule)
  puts "\nScheduling Plan:"
  headers = ["Date", "Time", "Building", "Room", "Capacity", "Computers", "Seating", "Seating Type", "Food Allowed", "Room Type", "Priority", "Purpose"]
  #Initialize an array to track the max width of each column based on the header length 
  column_widths = headers.map(&:length)

  # Iterate over each scheduled event to adjust column widths based on the length of their respective data
  # Adjust column widths based on the schedule data provded 
  schedule.each do |entry|
    column_widths[0] = [column_widths[0], entry[:date].to_s.length].max
    column_widths[1] = [column_widths[1], entry[:time].to_s.length].max
    column_widths[2] = [column_widths[2], entry[:room].building.length].max
    column_widths[3] = [column_widths[3], entry[:room].room.length].max
    column_widths[4] = [column_widths[4], entry[:room].capacity.to_s.length].max
    column_widths[5] = [column_widths[5], (entry[:room].computers ? 'Yes' : 'No').length].max
    column_widths[6] = [column_widths[6], entry[:room].seating.length].max
    column_widths[7] = [column_widths[7], entry[:room].seating_type.length].max
    column_widths[8] = [column_widths[8], (entry[:room].food_allowed ? 'Yes' : 'No').length].max
    column_widths[9] = [column_widths[9], entry[:room].room_type.length].max
    column_widths[10] = [column_widths[10], entry[:room].priority.length].max
    column_widths[11] = [column_widths[11], entry[:purpose].length].max
  end

  # Print the header row
  headers.each_with_index do |header, index|
    print header.ljust(column_widths[index] + 2)  #+2 for padding between columns
  end
  puts 
  # Prints each entry in the schedule beneath its corresponding header
  #The .ljust(column_widths[n] + 2) method is used to left-justify each piece of data within its column, using the maximum 
  #width for that column plus an additional 2 spaces for padding
  schedule.each do |entry|
    print entry[:date].to_s.ljust(column_widths[0] + 2)
    print entry[:time].to_s.ljust(column_widths[1] + 2)
    print entry[:room].building.ljust(column_widths[2] + 2)
    print entry[:room].room.ljust(column_widths[3] + 2)
    print entry[:room].capacity.to_s.ljust(column_widths[4] + 2)
    print (entry[:room].computers ? 'Yes' : 'No').ljust(column_widths[5] + 2)
    print entry[:room].seating.ljust(column_widths[6] + 2)
    print entry[:room].seating_type.ljust(column_widths[7] + 2)
    print (entry[:room].food_allowed ? 'Yes' : 'No').ljust(column_widths[8] + 2)
    print entry[:room].room_type.ljust(column_widths[9] + 2)
    print entry[:room].priority.ljust(column_widths[10] + 2)
    print entry[:purpose].ljust(column_widths[11] + 2)
    puts
  end 
end


#Function to get user input for event scheduling 
#date of event input
def get_user_input
  puts "Please enter the event details for a scheduling plan:"
  #promts  for and validates the date of the event
  date_valid = false
  date = ''
  until date_valid
    print "Date of event (yyyy-mm-dd): "
    date_input = gets.chomp
    # Checks if the input matches the expected format and is a future date
    if date_input.match(/\A\d{4}-\d{2}-\d{2}\z/)
      begin
        parsed_date = Date.parse(date_input)
        if parsed_date >= Date.today # Checks if the parsed date is today or in the future.
          date = parsed_date.strftime("%Y-%m-%d")
          date_valid = true
        else
          puts "Invalid input. Please enter a future date"
        end
      rescue ArgumentError
        puts "Invalid input. Please enter a date in the format yyyy-mm-dd."
      end
    else
      puts "Invalid input. Please enter a date in the format yyyy-mm-dd."
    end
  end
    
  #start time of event input  
  start_time_valid = false 
  start_time = '' 
  until start_time_valid
    print "Start time of the event (hh:mm AM/PM): "
    start_time_input = gets.chomp
    #check if entered time matches the expected format
    if start_time_input.match(/\A\d{1,2}:\d{2}\s[AP]M\z/) 
      hour, minute, period = start_time_input.split(/[:\s]/)
      hour = hour.to_i
      minute = minute.to_i
      #validates if the hour is within 12 hour clock range and 0-59 mins range
      if hour.between?(1, 12) && minute.between?(0, 59) && ["AM", "PM"].include?(period)
        start_time = start_time_input
        start_time_valid = true
      else
        puts "Invalid input. Please enter a valid time."
      end
    else
      puts "Invalid input. Please enter a valid time in the format hh:mm AM/PM."
    end
  end

  #duration of the event input  
  duration_valid = false
  #variable to store the duration once a valid input is received
  duration = '' 
  until duration_valid
    print "Duration of the event (hh:mm): "
    duration_input = gets.chomp
    #check if entered duration matches the expected format
    if duration_input.match(/\A\d{1,2}:\d{2}\z/) 
      hours, minutes = duration_input.split(':').map(&:to_i)
      #validate that hours and mins are non-neg and total duration is > 0
      if hours >= 0 && minutes >= 0 && (hours > 0 || minutes > 0)
        duration = duration_input
        duration_valid = true
      else
        puts "Invalid input. Duration must be a positive time period"
      end
    else
      puts "Invalid input. Please enter a valid duration in hh:mm format."
    end
  end

  #number of attendees input
  attendees_valid = false
  attendees = 0
  until attendees_valid
    print "Number of attendees: "
    attendees_input = gets.chomp
    #check if the input is a pos integer
    if attendees_input.match(/\A\d+\z/) && !attendees_input.empty?
       #converts the input string to an interger 
      attendees = attendees_input.to_i
      attendees_valid = attendees > 0
      puts "Invalid input. Please enter a valid positive number of attendees." unless attendees_valid
    else
      puts "Invalid input. Please enter a valid number of attendees."
    end
  end
  #After collecting and validating all inputs, returns a hash with the event's date, start time, duration, and number of attendees.
  { date: Date.parse(date), start_time: Time.parse(start_time), duration: duration, attendees: attendees }
end


# Function to check if a room is available 
def check_if_room_available(reserved_rooms, room, event_date, event_time, duration)
  #Splits the duration string into hours and minutes and converts them into integers
  duration_hours, duration_minutes = duration.split(':').map(&:to_i) 
  event_end_time = event_time + (duration_hours * 60 * 60) + (duration_minutes * 60)
    #Iterates over the array of reserved rooms to check if any reservation conflicts with the requested reservation
    reserved_rooms.none? do |reserved|
    reserved.building == room.building && reserved.room == room.room &&
    reserved.date == event_date && !(reserved.time...reserved.time + reserved.duration).overlaps?(event_time...event_end_time)
  end 
end

# Function that calculates the end time from start time and its duration of the event
def end_time_calculation(start_time, duration)
  hours, minutes = duration.split(':').map(&:to_i)
  #Calculates the end time by adding the duration (converted into seconds) to the start time
  end_time = start_time + (hours * 60 * 60) + (minutes * 60) 
  end_time.strftime("%I:%M %p")
end

# Function to check rooms based on the given constraints 
def finding_suitable_rooms(rooms, attendees, required_features)
  rooms.select do |room|
    #Filters the rooms based on the capacity and required features 
    room.capacity >= attendees && required_features.all? { |key, value| room.send(key) == value }
  end.sort_by { |room| (room.capacity - attendees).abs}
end

# Main scheduling function 
def schedule_events(rooms, reserved_rooms, event_details)
  # Extracting event details
  event_date = event_details[:date]
  event_start_time = event_details[:start_time]
  event_duration = event_details[:duration].split(":").map(&:to_i)
  total_event_duration = event_duration[0] + event_duration[1] / 60.0
  attendees = event_details[:attendees]
  
  
  # Variables for meal planning
  average_meal_attendees = attendees * 0.6 
  meal_duration_hours = 1 # Duration of the meal in hours
  opening_session_duration_hours = 1
  closing_session_duration_hours = 3

  #Subtract the opening session duration from the total event duration
  total_event_duration -= opening_session_duration_hours

  # Start scheduling
  schedule = []

  # keeps track of rooms used for opening and closing sessions
  used_for_opening_or_closing = []
 
  # keep track of the preffered building based on the opening sesion
  preferred_building = nil

  # Opening session
  opening_rooms = finding_suitable_rooms(rooms, attendees, { 'computers' => false })
  grouped_rooms = opening_rooms.group_by(&:building)
  sorted_buildings = grouped_rooms.keys.sort_by { |building| -grouped_rooms[building].size }
  opening_room = grouped_rooms[sorted_buildings.first].first
  # Add the opening room to the exclusion list
  used_for_opening_or_closing << opening_room 
  #set the preferred building based on opening sesion
  preferred_building = opening_room.building 
  formatted_time = event_start_time.strftime("%I:%M %p")
  schedule << { date: event_date, time: formatted_time, room: opening_room, purpose: "Opening Session" }

  # Initialize current time
  current_time = event_start_time.is_a?(Time) ? event_start_time : Time.parse(event_start_time)
 
  # Initialize a loop counter to prevent infinite loop
  loop_counter = 0
  #limit of iterations to avoid infinite loop
  max_loops = 100 

  # Calculate the closing session's date and time 
  final_event_time = add_hours_to_time(Time.parse("#{event_date} #{event_start_time}"), total_event_duration)
  closing_date = final_event_time.strftime("%Y-%m-%d")
  formatted_closing_time = final_event_time.strftime("%I:%M:%p")


   # Time for a meal
   meal_rooms = finding_suitable_rooms(rooms, average_meal_attendees, { 'food_allowed' => true })
   

  #Filter the meal rooms based on capacity and preferred building
  meal_rooms_needed = meal_rooms.select do |room|
    room.capacity >= 0.6 * attendees && room.building == preferred_building
  end 
   

   # Allocate different rooms for meals if needed
  meal_rooms_needed.each do |room|
    meal_time = add_hours_to_time(current_time, meal_duration_hours)
    meal_date = meal_time.strftime("%Y-%m-%d")
     
    schedule << { date: event_date, time: current_time.strftime("%I:%M %p"), room: meal_rooms.first, purpose: "Meal" }
  end 
     

    #Ensure at least 1 meal room is scheduled if any are needed
    if meal_rooms_needed.empty? && !meal_rooms.empty?
      # Choose the first available meal room if none in the preferred building meet the criteria
      first_available_room = meal_rooms.first
      schedule << {date: event_date, time: current_time.strftime("%I:%M %p"), room: first_available_room, purpose: "Meal"}

      puts "Scheduled Meal: Date: #{event_date}, Time: #{current_time.strftime("%I:%M %p")}, Room: #{first_available_room.building} #{first_available_room.room}, Purpose: Meal"
    end 


  while (total_event_duration > closing_session_duration_hours) && (loop_counter < max_loops)
    loop_counter += 1

    #check for meal time here 
    if total_event_duration - meal_duration_hours > closing_session_duration_hours
    
      # Update current time and total event duration
      #Converts meal_duration_hours to seconds (multiplying by 3600) before adding to current_time
      current_time = add_hours_to_time(current_time, meal_duration_hours) 
      total_event_duration -= meal_duration_hours
      
    else
      # Calculate duration for group work (dynamic approach for group work)
      group_work_duration_hours = [total_event_duration - closing_session_duration_hours, 0].max.floor
      if group_work_duration_hours > 0
        #group_work_duration_hours = group_work_duration.floor
        group_work_rooms = finding_suitable_rooms(rooms, attendees * 0.1, { 'computers' => true })
                          .sort_by { |room| room.building == preferred_building ? 0 : 1}
                          .reject { |room| used_for_opening_or_closing.include?(room) }
        
        #work rooms #{group_work_rooms.length()}"                  
        current_attendees = attendees
        group_work_rooms.each do |group_room| 
          #puts "group_room.building #{group_room.building}" 
          if current_attendees > 0
            schedule << { date: event_date, time: current_time.strftime("%I:%M %p"), room: group_room, purpose: "Group Work" }
            current_attendees -= group_room.capacity 
          end 
        end
      end 
      # Update current time, total event duration, and time since last meal
      current_time = add_hours_to_time(current_time, group_work_duration_hours)
      total_event_duration -= group_work_duration_hours
      #time_since_last_meal += group_work_duration_hours
      break
    end
  end

  
  # make sure there is enough time for the closing session
  if total_event_duration >= closing_session_duration_hours
    #find a room that can accommodate all attendees
    closing_rooms = finding_suitable_rooms(rooms, attendees, { 'computers' => false })
                    .sort_by { |room| room.building == preferred_building ? 0 : 1 }
                    .reject { |room| used_for_opening_or_closing.include?(room) }
    closing_room = closing_rooms.first

    if closing_room
      schedule << { date: closing_date, time: formatted_closing_time, room: closing_room, purpose: "Closing Session" }
    else
      # Handles when no suitable room found for closing session
      puts "Error: No suitable room found for closing session"
    end
  else
    # handles when not enough time for closing session
    puts "Error: Not enough time available for closing session"
  end

  schedule
  #puts "ending attendees: #{attendees} " 
end

 #helper method to add hours to a Time object and calculate the correct date and time 
def add_hours_to_time(original_time, hours_to_add) 
  final_time = original_time + (hours_to_add * 60 * 60) #convert hours to seconds
  final_time
end 


#Function to get a valid filename input from the user for the scheduling plan
def get_filename_input
  valid_filename = false
  filename = ''

  while !valid_filename
    print "Enter the filename for the scheduling plan (only letters, no special characters or numbers): "
    filename = gets.chomp

    if filename.match?(/\A[A-Za-z]+\.csv\z/)
      valid_filename = true
    else
      puts "Invalid filename. Please use only letters and do not leave it blank."
    end
  end

  filename
end



# Main execution
puts "Please enter the names of the input files:"

#Get the file names 
rooms_file = get_input_filename("Enter the filename for the rooms list (e.g., rooms_list.csv): ")
reserved_rooms_file = get_input_filename("Enter the filename for the reserved rooms (e.g., reserved_rooms.csv): ")

#Read the list of rooms from both files 
rooms = read_rooms_on_campus(rooms_file)
reserved_rooms = read_reserved_rooms(reserved_rooms_file)

#Collect event details from the user
event_details = get_user_input

#Schedule the event based on the provided details 
schedule = schedule_events(rooms, reserved_rooms, event_details) 

#print scheduling plan to screen
print_scheduling_plan_on_screen(schedule)

#Prompt the user to enter a filename for exporting the schedule and write the plan to the specified file
file_name = get_filename_input
write_scheduling_plan(schedule, file_name)