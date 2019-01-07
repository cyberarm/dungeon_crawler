require "gosu"
require_relative "lib/map"

class Window < Gosu::Window
  def initialize
    super(1280, 600, false)

    @size = 16.0
    @_width  = (self.width  / @size).floor
    @_height = (self.height / @size).floor
    @_tunnels= 512
    @_max_length = 4

    @map = Map.new(width: @_width, height: @_height, tunnels: @_tunnels, max_length: @_max_length, size: @size.floor)

    @font = Gosu::Font.new(18)
  end

  def needs_cursor?
    true
  end

  def draw
    @map.draw(@font)

    @font.draw_text("Mouse: #{normalize(mouse_x)}:#{normalize(mouse_y)}", 10, 10, 0)
    @font.draw_text("Map Size: #{@_width}:#{@_height}", 10, 28, 0)
  end

  def update
    @map.update
  end

  def button_up(id)
    if id == Gosu::KbF5
      @map = Map.new(width: @_width, height: @_height, tunnels: @_tunnels, max_length: @_max_length, size: @size.floor)
    end
  end

  def button_down(id)
    if id == Gosu::KbS && (button_down?(Gosu::KbLeftControl) || button_down?(Gosu::KbRightControl))
      save_map
    end
  end

  def save_map
    puts "Saving..."
    buffer = ""

    @map.height.times do |y|
      @map.width.times do |x|
        if @map.tiles[x][y].type == :wall
          buffer+="#"
        else
          buffer+="-"
        end
      end
      buffer+="\n"
    end

    File.open("data/map_#{Time.now.to_i}.txt", "w") {|f| f.write(buffer) }
    puts "Saved."
  end

  def normalize(n)
    (n / @size).floor
  end
end

Window.new.show