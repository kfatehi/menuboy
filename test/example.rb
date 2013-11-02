require 'menuboy'

Menuboy.menu('main menu') do |menu|
  menu.option("start the stack") do
    puts "hi"
  end
  menu.option("drop a database") do |dropper|
    dropper.menu("which database?") do |db|
      db.option("this one") do 
        puts "sounds good"
      end
      db.option("that one") do
        puts "ok"
      end
    end
  end
end
