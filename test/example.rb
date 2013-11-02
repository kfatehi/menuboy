require 'menuboy'

Menuboy.menu('main menu') do |m|
  m.opt("start the stack") do
    puts "hi"
  end
  m.opt("drop a database") do
    puts "bye"
  end
end
