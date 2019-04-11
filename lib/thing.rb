# Anything that is not a ceiling, floor, or wall is a thing.
# a Thing is a "billboards" which alway faces the player.
class Thing < Entity
  include OpenGL

  attr_reader :map, :options
  attr_accessor :drawable, :position, :orientation
  def initialize(map, x, y, options = {})
    # X -> Roll
    # Y -> Yaw
    # Z -> Pitch
    x += 0.5
    y += 0.5 # + 0.5 to center on tile
    @orientation = Vector.new

    @list_id = glGenLists(1)
    @list_filled = false
    @drawable = true
    super(map, x, y, options)

    @verts = @faces.map {|f| f.vertices}.flatten.uniq!
    @min = @verts.sample
    @max = @verts.sample

    @verts.each do |vert|
      @min = vert.clone if vert.sum < @min.sum
      @max = vert.clone if vert.sum > @max.sum
    end

    @center = (@max+@min)/2.0
    @origin = Vector.new(0,0,0)
  end

  def rotate_x!(degrees)
    radians = degrees.degrees_to_radians

    @verts.each do |vert|
      offset = (vert - @origin)
      vert.y = (offset.z * Math.sin(radians) + offset.y * Math.cos(radians)) + @origin.y
      vert.z = (offset.z * Math.cos(radians) - offset.y * Math.sin(radians)) + @origin.z
    end

    @list_filled = false
  end

  def rotate_y!(degrees)
    radians = degrees.degrees_to_radians

    @verts.each do |vert|
      offset = (vert - @origin)
      vert.x = (offset.z * Math.sin(radians) + offset.x * Math.cos(radians)) + @origin.x
      vert.z = (offset.z * Math.cos(radians) - offset.x * Math.sin(radians)) + @origin.z
    end

    @list_filled = false
  end

  def rotate_z!(degrees)
    radians = degrees.degrees_to_radians

    @verts.each do |vert|
      offset = (vert - @origin)
      vert.x = (offset.y * Math.sin(radians) + offset.x * Math.cos(radians)) + @origin.x
      vert.y = (offset.y * Math.cos(radians) - offset.x * Math.sin(radians)) + @origin.y
    end

    @list_filled = false
  end

  def draw
    return unless @drawable
    unless @list_filled
      @list_filled = true

      glNewList(@list_id, GL_COMPILE)

      Texture.all.each do |texture|
        if texture
          glEnable(GL_TEXTURE_2D)
          glBindTexture(GL_TEXTURE_2D, texture)
          Shader.set_uniform("in_NoTexture", 0.0)
        else
          Shader.set_uniform("in_NoTexture", 1.0)
        end

        glBegin(GL_TRIANGLES)
          @faces.select {|f| f.texture == texture}.each do |face|
            face.draw
          end
        glEnd

        glDisable(GL_TEXTURE_2D) if texture
      end
      glEndList
    end


    glPushMatrix
    glTranslatef(@position.x, @position.y, @position.z)
    glRotatef(@orientation.z, 1, 0, 0) # pitch
    glRotatef(@orientation.y, 0, 1, 0) # yaw
    glRotatef(@orientation.x, 0, 0, 1) # roll

    glCallList(@list_id)
    glPopMatrix
  end

  def drawable?
    @drawable
  end

  def update
    @behavior.update if @behavior
  end
end