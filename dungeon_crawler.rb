require "gosu"
require "opengl"
require "glu"
require_relative "lib/opengl_lib"
require_relative "lib/vector"
require_relative "lib/state"
require_relative "lib/map"
require_relative "lib/states/map_builder"
require_relative "lib/states/map_player"
require_relative "lib/player"

class Window < Gosu::Window
  def initialize
    super(1280, 600, false)

    @current_state = MapBuilder.new(window: self)
  end

  def draw
    @current_state.draw
  end

  def update
    @current_state.update
  end

  def state=(state)
    @current_state = state
  end

  def needs_cursor?
    @current_state.needs_cursor?
  end

  def button_down(id)
    super
    @current_state.button_down(id)
  end

  def button_up(id)
    super
    @current_state.button_up(id)
  end
end

Window.new.show