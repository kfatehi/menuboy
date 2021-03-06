# Menuboy

Ultrasimple command-line menu/submenu DSL

WARNING: I didn't use TDD to develop this -- it is an extraction out of
a custom script I developed for the non-backend-coders to use for
managing our node.js/mongodb/redis stack in a super simple way. You can
see the basic idea of that in test/example.rb, which was used to develop
menuboy.

---

### v0.2.0
* Add ability to pass input from the command line.
  e.g. `test/example.rb 2 q 2 1 1` will enter these inputs immediately
  as though typed by the user, navigating through the menus and
  selecting options

### v0.1.1
* Fix bug where STDIN would not return to normal under linux

### v0.1.0
* Remove `STDIN.getch` loop approach which was causing formatting
  issues with other programs trying to write to STDOUT
* Use EventMachine to capture keyboard input
* Use ruby-termios to enable raw keyboard capture
* Provide `Menuboy#fix_stdin` public helper method to temporary re-enable
  normal stdin behavior

## Installation

Add this line to your application's Gemfile:

    gem 'menuboy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install menuboy

## Usage

Say you write a menuboy script like this:

```ruby
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
```

You can then run the script and have such an interaction:

```
$prompt> ruby simple.rb
1 - say cheese!
2 - animal sounds
q - quit / go back
(Main Menu)> 1
CHEESE!
(Main Menu)> 2
1 - duck sounds
q - quit / go back
(animal sounds)> h
1 - duck sounds
q - quit / go back
(animal sounds)> 1
1 - loud quack
2 - soft quack
q - quit / go back
(duck sounds)> 1
QUACK!!!
(duck sounds)> 2
quack!
(duck sounds)> q
(animal sounds)> h
1 - duck sounds
q - quit / go back
(animal sounds)> q
(Main Menu)> q
$prompt>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

