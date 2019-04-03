class Player
  include OpenGL
  include GLU

  attr_accessor :position, :orientation
  def initialize(options = {})
    @options = options
    @window = options[:window]
    @map    = options[:map]

    @head_height = -0.5
    @head_bob_position = 0
    @head_bob_speed    = 0.2
    @head_bob_factor   = 0.015

    @position = Vector.new(options[:x], @head_height, options[:y])
    @new_position = Vector.new

    @orientation = Vector.new(0, 0, 0)

    @turn_speed = 50.0
    @speed = 1.5

    @field_of_view = 45.0
    @view_distance = 50.0
    @min_wall_distance = 0.25

    @mouse_pos = @window.mouse_x
    @mouse_sensitivity = 0.1

    @sky = Gosu::Color::BLACK
    @gl_sky = GLColor.new(@sky.red / 255.0, @sky.green / 255.0, @sky.blue / 255.0, @sky.alpha / 255.0)
  end

  def camera
    glClearColor(@gl_sky.red, @gl_sky.green, @gl_sky.blue, @gl_sky.alpha)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) # clear the screen and the depth buffer

    #glMatrixMode(matrix) indicates that following [matrix] is going to get used
    glMatrixMode(GL_PROJECTION) # The projection matrix is responsible for adding perspective to our scene.
    glLoadIdentity # Resets current modelview matrix
    # Calculates aspect ratio of the window. Gets perspective  view. 45 is degree viewing angle, (0.1, 100) are ranges how deep can we draw into the screen
    gluPerspective(@field_of_view, @window.width / @window.height, 0.1, @view_distance)
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
    glMatrixMode(GL_MODELVIEW) # The modelview matrix is where object information is stored.
    glLoadIdentity
    glEnable(GL_DEPTH_TEST)
    glShadeModel(GL_FLAT)

    glRotatef(@orientation.y, 0, 1, 0)
    glTranslatef(-@position.x, @position.y, -@position.z)

    @window.handle_gl_error
  end

  def update
    # Use vector math to prevent diagonal speed increase
    normalized = @new_position.normalized
    moved = move(normalized)

    bob_head if moved && @new_position.magnitude.abs > 0.001
    mouse_look
    @new_position = Vector.new
  end

  def speed
    @window.delta * @speed
  end

  def turn_speed
    @window.delta * @turn_speed
  end

  def forward
    @new_position.z -= Math.cos((@orientation.y).degrees_to_radians) * speed
    @new_position.x += Math.sin((@orientation.y).degrees_to_radians) * speed
  end

  def backward
    @new_position.z += Math.cos((@orientation.y).degrees_to_radians) * speed
    @new_position.x -= Math.sin((@orientation.y).degrees_to_radians) * speed
  end

  def strafe_left
    @new_position.z -= Math.sin((@orientation.y).degrees_to_radians) * speed
    @new_position.x -= Math.cos((@orientation.y).degrees_to_radians) * speed
  end

  def strafe_right
    @new_position.z += Math.sin((@orientation.y).degrees_to_radians) * speed
    @new_position.x += Math.cos((@orientation.y).degrees_to_radians) * speed
  end

  def turn_left
    @orientation.y -= turn_speed
    @orientation.y %= 359.0
  end

  def turn_right
    @orientation.y += turn_speed
    @orientation.y %= 359.0
  end

  def move(normalized)
    moved = true
    x_tile = @map.tiles.dig((@position.x + normalized.x * speed + (normalized.x * @min_wall_distance)).to_i, @position.z.to_i)
    z_tile = @map.tiles.dig(@position.x.to_i, (@position.z + normalized.z * speed + (normalized.z * @min_wall_distance)).to_i)

    nx = Vector.new(normalized.x)
    nz = Vector.new(0, 0, normalized.z)

    if x_tile[:type] == :floor && z_tile[:type] == :floor
      @position += (nx + nz) * speed
    elsif x_tile[:type] == :floor
      @position += nx * speed
    elsif z_tile[:type] == :floor
      @position += nz * speed
    else
      moved = false
    end

    return moved
  end

  def bob_head
    @head_bob_position += @head_bob_speed
    @position.y = (Math.sin(@head_bob_position) * @head_bob_factor) + @head_height
  end

  def mouse_look
    x = @window.mouse_x
    @orientation.y -= (@mouse_pos - x) * @mouse_sensitivity

    @window.mouse_x = @window.width/2 if x < 1 || x > @window.width - 1
    @mouse_pos = @window.mouse_x
  end
end