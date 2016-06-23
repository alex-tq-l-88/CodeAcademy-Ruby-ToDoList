#main ruby file for project

#module to display menu of options
module Menu
	def menu
		"Welcome to the ToDo List Program!
		This menu will help you use the Task List System
		Press '1': Add a new task
		Press '2': Show the current to-do list
		Press '3': Delete a task
		Press '4': Update a task
		Press '5': Toggle task status (i.e. complete vs incomplete)
		Press '6': Write list to a file
		Press '7': Read a file
		Press 'Q': Quit the program
"
	end

	def show
		menu
	end

end

#Module to prompt use for direction 
module Promptable
	def prompt(message = 'What would you like to do?', symbol = ':>')
	print message
	print symbol
	gets.chomp
	end

end

#creating a class to manage the each to-do list 
class List 
	attr_reader :all_task #allows people to read the all_task attribute

	def initialize #method: action upon creating list
		@all_task = []
	end

	def add(task) #method: adding a new task
		unless task.to_s.chomp.empty?
			@all_task << task #adding new task to array
		end
	end

	def delete(task_number) #deleting a task (note: array starts at 0)
		all_task.delete_at(task_number - 1)
	end

	def update(task_number, task) #updating a task (note: array starts at 0)
		all_task[task_number - 1] = task
	end

	def show #show the current to-do list
		all_task.map.with_index { |l, i| "(#{i.next}): #{l}"}
	end

	def write_to_file(filename) #enables writing to-do list to files
		machinified = @all_tasks.map(&:to_machine).join("\n")
        IO.write(filename, machinified)
	end

	def read_from_file(filename) #enables reading to-do list from files
		IO.readlines(filename).each do |line|
            status, *description = line.split(':')
            status = status.include?('X')
            add(Task.new(description.join(':').strip, status))
        end
	end

	def toggle(task_number) #toggle status for given task
		all_task[task_number - 1].toggle_status
	end

end


#creating a class to manage all the tasks on the to-do list
class Task
	attr_reader :description #make description readable
	attr_accessor :completed_status #make status readable and editable

	def initialize(description, completed_status = false) #initialise new task w/ descrpition and status
            @description = description
            @completed_status = completed_status
    end

    def to_s #method defining how tasks are to be displayed
    	"#{represent_status} : #{description}"
    end

    def completed? #boolean display of whether task is completed
    	completed_status
    end

    def toggle_status #negates the completed? method, setting it to opposite
    	@completed_status = !completed?
    end

    def to_machine
    	"#{represent_status}: #{description}"
    end

    private #make method private for this class

    def represent_status
    	"#{completed? ? '[x]' : '[ ]'}" #ternary operator... if completed true, then [X]...
    end


end

#program runner 
if __FILE__ == $PROGRAM_NAME
          include Menu
          include Promptable
          my_list = List.new #puts message when action is initialisted
          puts "Please choose from the following list"
          	until ['q'].include?(user_input = prompt(show).downcase)
          		case user_input
          			when '1'
          				my_list.add(Task.new(prompt('What is the task you would like to accomplish?')))      			
          			when '2'
          				puts my_list.show
          			when '3' 
          				puts my_list.show
          				my_list.delete(prompt('Which task (#) to delete?').to_i)
          			when '4'
          				puts my_list.show
          				my_list.update(prompt('Which task (#) to update?').to_i, Task.new(prompt('New task description:')))
          			when '5'
          				puts my_list.show
          				my_list.toggle(prompt('Which task would you like to toggle status for?').to_i)
          			when '6'
          				my_list.write_to_file(prompt('What is the filename to write to?'))
          			when '7'
          				begin
                  			my_list.read_from_file(prompt('What is the filename to read from?'))
                		rescue Errno::ENOENT
                  			puts 'File name not found, please verify your file name and path.'
                	end
          			else 
          				puts 'sorry, I did not understand'
          			end
          			prompt('Press enter to continue','')
			end
		puts 'Outro - Thanks for using the menu system!'
end 