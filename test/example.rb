#!/usr/bin/env ruby
require 'pry'
require 'menuboy'

module StackCLI
  extend Menuboy::DSL

  menu "Main Menu" do
    option "start the stack"  do
      puts "hi"
    end
    # menu "database options" do
    #   option "drop database" do
    #     puts "database dropped!"
    #   end
    #   option "seed database" do
    #     puts "database seeded!"
    #   end
    # end
  end
end
