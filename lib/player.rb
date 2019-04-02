class Player
  include OpenGL
  include GLU

  attr_accessor :position
  def initialize(options = {})
    @options = options
    @window = options[:window]

    @position = Vector.new(options[:x], 0, options[:y])
    @turn_speed = 25.0
    @speed = 1.0

    @field_of_view = 45.0
    @view_distance = 50.0
  end

  def camera
    #glMatrixMode(matrix) indicates that following [matrix] is going to get used
    glMatrixMode(GL_PROJECTION) # The projection matrix is responsible for adding perspective to our scene.
    glLoadIdentity # Resets current modelview matrix
    # Calculates aspect ratio of the window. Gets perspective  view. 45 is degree viewing angle, (0.1, 100) are ranges how deep can we draw into the screen
    gluPerspective(@field_of_view, @window.width / @window.height, 0.1, @view_distance)
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
    glRotatef(@position.y, 0, 1, 0)
    glTranslatef(-@position.x, -1.0, -@position.z)
    glMatrixMode(GL_MODELVIEW) # The modelview matrix is where object information is stored.
    glLoadIdentity

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
  end

  def backward
    @position.z += Math.cos((@position.y).degrees_to_radians) * speed
    @position.x -= Math.sin((@position.y).degrees_to_radians) * speed
  end

  def turn_left
    @position.y -= turn_speed
  end

  def turn_right
    @position.y += turn_speed
  end
end