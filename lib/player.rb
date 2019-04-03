class Player
  include OpenGL
  include GLU

  attr_accessor :position, :orientation
  def initialize(options = {})
    @options = options
    @window = options[:window]

    @position = Vector.new(options[:x], 0, options[:y])

    @head_height = -0.5
    @orientation = Vector.new(0, @head_height, 0)
    @head_bob_position = 0
    @head_bob_speed    = 0.2
    @head_bob_factor   = 0.02

    @turn_speed = 50.0
    @speed = 4.0

    @field_of_view = 45.0
    @view_distance = 50.0

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

    glRotatef(@position.y, 0, 1, 0)
    glTranslatef(-@position.x, @orientation.y, -@position.z)

    @window.handle_gl_error
  end

  def speed
    @window.delta * @speed
  end

  def turn_speed
    @window.delta * @turn_speed
  end

  def forward
    @position.z -= Math.cos((@position.y).degrees_to_radians) * speed
    @position.x += Math.sin((@position.y).degrees_to_radians) * speed

    bob_head
  end

  def backward
    @position.z += Math.cos((@position.y).degrees_to_radians) * speed
    @position.x -= Math.sin((@position.y).degrees_to_radians) * speed

    bob_head
  end

  def strafe_left
    @position.z -= Math.sin((@position.y).degrees_to_radians) * speed
    @position.x -= Math.cos((@position.y).degrees_to_radians) * speed

    bob_head
  end

  def strafe_right
    @position.z += Math.sin((@position.y).degrees_to_radians) * speed
    @position.x += Math.cos((@position.y).degrees_to_radians) * speed

    bob_head
  end

  def turn_left
    @position.y -= turn_speed
    @position.y %= 359.0
  end

  def turn_right
    @position.y += turn_speed
    @position.y %= 359.0
  end

  def bob_head
    @head_bob_position += @head_bob_speed
    @orientation.y = (Math.sin(@head_bob_position) * @head_bob_factor) + @head_height
  end
end