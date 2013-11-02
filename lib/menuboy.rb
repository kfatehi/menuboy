require "menuboy/version"
require 'pry'

module Menuboy
  class Option < Struct.new(:key, :name, :proc)
  end

  class Menu
    def initialize name
      @opts = []
    end

    def opt name, &block
      @opts.push Option.new(@opts.count+1, name, block)
    end
  end

  def self.menu(name="MenuBoy!")
    @options = yield Menu.new(name)
    binding.pry
  end
end
