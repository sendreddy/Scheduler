#Project Name: Assignment 1 Room Reservation Project 
#Description: This project will allow the user to reserve a room on campus for a specified duration of time. The user is prompted to enter some 
              #of the details about the room, and then the program will check if the room is available for the specified duration.
              #It will then print out the details of the available room on screen and generates a .csv file also. 
#Filename: reserved_rooms.rb
#Description: This class encapsulates information about room reservations. When setting up a new booking, the program carefully checks the date
              #the date to make sure it is correct. If there is a mistake with the date, it won't stop the program. Instead it just doesn't save
              #the date. 
#Last Modified: 3/1/24


# Class to represent the reserved rooms
class ReservedRooms
    #creates getter methods for these attributes so they can be read outside the class 
    attr_reader :building, :room, :date, :time, :duration, :booking_type
  
    #Initialize a new instance of the ReservedRoom class that stores the building of the reserved room,
    #the room number, duration of the booking, and the type of booking
    def initialize(building, room, date, time, duration, booking_type)
      @building = building
      @room = room

      #Try to parse the date and also handle any expections
      begin 
        @date = Date.parse(date)
      rescue ArgumentError => e
        #If there's an error is parsing the date, @date is set to nul and the error is not raised
        @date = nil 
      end 

      @time = Time.parse(time) #parses the 'time' string into a Time object
      @duration = duration
      @booking_type = booking_type
    end 
  end 