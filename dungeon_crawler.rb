require "gosu"
require "opengl"
require "glu"

require_relative "lib/opengl_lib"
require_relative "lib/shaders/shader"
require_relative "lib/vector"
require_relative "lib/state"
require_relative "lib/map"
require_relative "lib/slot"
require_relative "lib/states/map_builder"
require_relative "lib/states/map_player"
require_relative "lib/player"

require_relative "lib/texture"
require_relative "lib/face"

require_relative "lib/wavefront/model"
require_relative "lib/wavefront/model_object"
require_relative "lib/wavefront/material"
require_relative "lib/wavefront/parser"

require_relative "lib/entity"
require_relative "lib/voxel"
require_relative "lib/thing"
require_relative "lib/behavior"
require_relative "lib/bounding_box"
require_relative "lib/ray"
require_relative "lib/collision_manager"

require_relative "lib/voxels/wall"
require_relative "lib/voxels/floor"
require_relative "lib/voxels/door"

require_relative "lib/things/barrel"
require_relative "lib/things/rising_door"
require_relative "lib/things/sliding_door"

require_relative "lib/behaviors/wander"
require_relative "lib/behaviors/rising_door"
require_relative "lib/behaviors/sliding_door"

require_relative "lib/level"
require_relative "lib/level/mesh"

GAME_ROOT_PATH = File.expand_path(File.dirname(__FILE__))

class Window < Gosu::Window
  include OpenGL
  include GLU

  def initialize
    super(1280, 600, false)
    # super(Gosu.screen_width, Gosu.screen_height, true)
    Window.instance = self

    self.caption = "Dungeon Crawler"
    @current_state = MapBuilder.new(window: self)
    @delta_time = Gosu.milliseconds
    @screenshot = false
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

  def self.instance
    @instance
  end

  def self.instance=(inst)
    raise ArgumentError, "Must be an instance of Window!" unless inst.is_a?(Window)
    @instance = inst
  end

  def self.handle_gl_error
    Window.instance.handle_gl_error
  end
end

Window.new.show