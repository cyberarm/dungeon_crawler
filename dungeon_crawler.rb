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
require_relative "lib/level"

class Window < Gosu::Window
  include OpenGL
  include GLU

  def initialize
    super(1280, 600, false)

    @current_state = MapBuilder.new(window: self)
    @delta_time = Gosu.milliseconds
  end

  def delta
    (Gosu.milliseconds - @delta_time) / 1000.0
  end

  def draw
    if @screenshot
      @screenshot = false
      Gosu.render(self.width, self.height) do
        @current_state.draw
      end.save("screenshot-#{Time.now.to_i}.png")
    end

    @current_state.draw
  end

  def update
    @current_state.update
    @delta_time = Gosu.milliseconds
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
    @screenshot = true if id == Gosu::KbF12
    @current_state.button_up(id)
  end

  def drop(file)
    @current_state.drop(file)
  end

  def handle_gl_error
    e = glGetError()
    if e != GL_NO_ERROR
      $stderr.puts "OpenGL error in: #{gluErrorString(e)} (#{e})\n"
      exit
    end
  end
end

Window.new.show