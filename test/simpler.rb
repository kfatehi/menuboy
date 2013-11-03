require 'menuboy'

include Menuboy::DSL

mainmenu "Main Menu" do
  option "say cheese!" do
    puts "CHEESE!"
  end

  submenu "animal sounds" do
    submenu "duck sounds" do
      option "loud quack" do
        puts "QUACK!!!"
      end

      option "soft quack" do
        puts "quack!"
      end
    end
  end
end
