require "menuboy/version"
require 'pry'

module Menuboy
  module DSL
    def option name, &block
      opt_count = @target.options.count
      key = (opt_count+1).to_s
      if key.size > 1
        raise StandardError, "You can only define 9 options per menu"
      end
      opt = Option.new(key, name, block)
      @target.options.push opt
    end

    def submenu name="Submenu"
      option(name) do
        @target = Menu.new(name)
        yield
        @target.start
      end
    end

    def mainmenu(name="Main menu")
      if @mainmenu
        raise StandardError, "You can only define one main menu"
      else
        @mainmenu = Menu.new(name)
        @target = @mainmenu
        yield
        @mainmenu.start
      end
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
