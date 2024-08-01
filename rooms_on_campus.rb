#Project Name: Assignment 1 Room Reservation Project 
#Description: This project will allow the user to reserve a room on campus for a specified duration of time. The user is prompted to enter some 
              #of the details about the room, and then the program will check if the room is available for the specified duration.
              #It will then print out the details of the available room on screen and generates a .csv file also. 
#Filename: rooms_on_campus.rb
#Description: This class is designed to manage and represent details about various rooms available on campus. It stores information such as the 
              #building name, room number, capacity, availability of computers, seating arrangements, whether food is allowed, room priority, and
              #the type of room. This class makes it easier to organize and access specific details about campus rooms.
#Last Modified: 3/1/24 


# Class to represent a room
class RoomsOnCampus
    #Allows read access to room attributes 
    attr_reader :building, :room, :capacity, :computers, :seating, :seating_type, :food_allowed, :priority, :room_type
  
    #constructor method to initialize a new Room object with specified attributes 
    def initialize(building, room, capacity, computers, seating, seating_type, food_allowed, priority, room_type)
      @building = building
      @room = room
      @capacity = capacity.to_i
      @computers = computers == 'Yes'
      @seating = seating
      @seating_type = seating_type
      @food_allowed = food_allowed == 'Yes'
      @priority = priority
      @room_type = room_type
    end 
  end 