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

    @strafe_tilt = 0.1
    @turn_speed = 50.0
    @speed = 1.5

    @field_of_view = 45.0
    @view_distance_near= 0.01
    @view_distance_far = 50.0

    @min_wall_distance = 0.2

    @mouse = Vector.new(@window.mouse_x, @window.mouse_y)
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
    gluPerspective(@field_of_view, @window.width / @window.height, @view_distance_near, @view_distance_far)
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
    glMatrixMode(GL_MODELVIEW) # The modelview matrix is where object information is stored.
    glLoadIdentity
    glEnable(GL_DEPTH_TEST)
    glShadeModel(GL_FLAT)

    glRotatef(@orientation.z, 1, 0, 0) # pitch
    glRotatef(@orientation.y, 0, 1, 0) # yaw
    glRotatef(@orientation.x, 0, 0, 1) # roll
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

    @orientation.x = -@strafe_tilt
  end

  def strafe_right
    @new_position.z += Math.sin((@orientation.y).degrees_to_radians) * speed
    @new_position.x += Math.cos((@orientation.y).degrees_to_radians) * speed

    @orientation.x = @strafe_tilt
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
    y = @window.mouse_y

    @orientation.y -= (@mouse.x - x) * @mouse_sensitivity
    @orientation.y %= 360.0

    if x < 1 || x > @window.width - 1
      @window.mouse_x = @window.width/2
      @mouse.x = @window.width/2
    else
      @mouse.x = @window.mouse_x
    end

    @orientation.z -= (@mouse.y - y) * @mouse_sensitivity
    @orientation.z = @orientation.z.clamp(-90.0, 90.0)

    if y < 1 || y > @window.height - 1
      @window.mouse_y = @window.height/2
      @mouse.y = @window.height/2
    else
      @mouse.y = @window.mouse_y
    end
  end
end