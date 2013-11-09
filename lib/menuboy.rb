require "menuboy/version"
require 'io/console'
require 'termios'
require 'eventmachine'


module Menuboy
  @termios_normal_attributes = Termios.tcgetattr($stdin).dup

  def self.raw_terminal
    attributes = @termios_normal_attributes.dup
    attributes.lflag &= ~Termios::ECHO
    attributes.lflag &= ~Termios::ICANON
    Termios::tcsetattr($stdin, Termios::TCSANOW, attributes)
  end

  def self.normal_terminal
    Termios::tcsetattr($stdin, Termios::TCSANOW, @termios_normal_attributes)
  end

  module UnbufferedKeyboardHandler
    def receive_data(k)
      puts k
      menu = Menuboy.menus.last
      if k == "q"
        Menuboy.menus.pop
        if next_menu = Menuboy.menus.last
          next_menu.print_help
        else
          exit # no more menus
        end
      else
        menu.handle_input(k)
      end
      Menuboy.menus.last.prompt
    end
  end

  ##
  # Use this if you need to re-enable buffering
  # as menuboy disables this by default on STDIN
  # You don't need this when using #system but
  # you'll want it if you get user input directly
  def self.fix_stdin
    self.normal_terminal
    yield
    self.raw_terminal
  end

  def self.menus
    @menus ||= []
  end

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
        Menuboy.menus.push @target
        @target.print_help
      end
    end

    def mainmenu(name="Main menu")
      if @mainmenu
        raise StandardError, "You can only define one main menu"
      else
        @target = @mainmenu = Menu.new(name)
        yield
        Menuboy.menus.push @target
        @target.print_help
        @target.prompt

        Signal.trap("INT") { exit }

        EM.run do
          Menuboy.raw_terminal
          EM.open_keyboard(UnbufferedKeyboardHandler)
        end
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
      puts "h - print help"
      puts "q - quit / go back"
    end

    def option_match? input
      matches = self.options.select{|o| o.key == input}
      matches.length == 1 ? matches.last : false
    end

    def handle_input k
      if k == "h"
        print_help
      elsif k == "p" && defined? Pry
        Menuboy.fix_stdin do
          binding.pry
        end
      elsif option = option_match?(k)
        option.proc.call
      else
        puts "Unassigned input"
      end
    end

    def prompt
      print "(#{@name})> "
    end
  end
end

