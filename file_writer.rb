#Project Name: Assignment 1 Room Reservation Project 
#Description: This project will allow the user to reserve a room on campus for a specified duration of time. The user is prompted to enter some 
              #of the details about the room, and then the program will check if the room is available for the specified duration.
              #It will then print out the details of the available room on screen and generates a .csv file also. 
#Filename: file_writer.rb
#Description: The FileWriter class provides a easy interface for writing text to files, allowing for the writing of individual lines or multiple
              #multiple lines separated by a comma. It also handles the opening, writing to, and closing of a file.  
#Last Modified: 2/8/24


# File writer class
class FileWriter
    #Initialize a FileWriter object with a file ready for writing 
    def initialize(filename)
      @file = File.open(filename, 'w') #opens the specified file in write mode (w)
    end
  
    #writes a single line to the file 
    def write_line(line)
      @file.puts(line) #writes the given line to the file, followed by a newline character
    end

    #writes multiple items to the file, separated by commas 
    def write(*args)
      @file.puts(args.join(','))
    end
  
    #close the file
    def close
      @file.close
    end
  end