#!/usr/bin/env ruby
require 'pry'
require 'menuboy'

@current_db = "identity"

include Menuboy::DSL

mainmenu "Main Menu" do
  option "start the stack" do
    if @started
      puts "Already started"
    else
      @started = true
      puts "Started!"
    end
  end

  submenu "database options" do
    puts "using #{@current_db}"

    submenu "change database" do
      option "identity" do
        @current_db = "identity"
        puts "using identity"
      end

      option "storage" do
        @current_db = "storage"
        puts "using storage"
      end
    end

    option "drop database" do
      puts "#{@current_db} dropped!"
    end

    option "seed database" do
      puts "#{@current_db} seeded!"
    end
  end
end
