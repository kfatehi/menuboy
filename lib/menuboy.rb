require "menuboy/version"
require 'pry'

module Menuboy
  module DSL
    def option name
      opt_count = self.options.count
      opt = Option.new((opt_count+1).to_s, name, yield)
      self.options.push opt
    end

    def menu(name="MenuBoy!")
      Menu.new(name, yield).start
    end
  end

  class Option < Struct.new(:key, :name, :proc)
  end

  class Menu
    include DSL
    attr_accessor :name, :options

    CTRL_C = "\u0003"

    def initialize name
      self.name = name
      self.options = []
    end

    def print_help
      self.options.each do |opt|
        puts "#{opt.key} - #{opt.name}"
      end
      puts "p - jump into a Pry repl" if defined? Pry
      puts "q - quit / go back"
    end

    def option_match? input
      matches = self.options.select{|o| o.key == input}
      matches.length == 1 ? matches.last : false
    end

    def start
      print_help
      loop do
        print "(#{@name})> "
        input = STDIN.getch
        puts input
        if input == CTRL_C || input == "q"
          break
        elsif input == "h"
          print_help
        elsif input == "p" && defined? Pry
          binding.pry
        elsif option = option_match?(input)
          option.proc.call
        else
          puts "Unassigned input"
        end
      end
    end
  end


end
