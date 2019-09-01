require "gosu"
require "opengl"
require "glu"

require "json"
require "securerandom"

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
require_relative "lib/things/planter"
require_relative "lib/things/rising_door"
require_relative "lib/things/sliding_door"

require_relative "lib/behaviors/wander"
require_relative "lib/behaviors/rising_door"
require_relative "lib/behaviors/sliding_door"

require_relative "lib/level"
require_relative "lib/level/mesh"

require_relative "lib/positional_sound/listener"
require_relative "lib/positional_sound/audio_source"

require_relative "lib/network/server"
require_relative "lib/network/client"

require_relative "lib/window"

GAME_ROOT_PATH = File.expand_path(File.dirname(__FILE__))


Thread.abort_on_exception = true
Window.new.show
