class Player
  attr_accessor :name

  def initialize
    @name = ""
  end

  def select_name
    puts "Enter your name:"
    @name = gets.chomp
  end
end