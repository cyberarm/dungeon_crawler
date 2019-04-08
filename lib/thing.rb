# Anything that is not a ceiling, floor, or wall is a thing.
# a Thing is a "billboards" which alway faces the player.
class Thing < Entity
  include OpenGL

  attr_reader :map
  attr_accessor :drawable, :position, :orientation
  def initialize(map, x, y, options = {})
    @position = Vector.new(x + 0.5, 0, y + 0.5) # + 0.5 to center on tile

    # X -> Roll
    # Y -> Yaw
    # Z -> Pitch
    @orientation = Vector.new

    @list_id = glGenLists(1)
    @list_filled = false
    @drawable = true
    super(map, x, y, options)
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

      glCallList(@list_id)
    else
      glPushMatrix
      glTranslatef(@position.x, @position.y, @position.z)
      glRotatef(@orientation.z, 1, 0, 0) # pitch
      glRotatef(@orientation.y, 0, 1, 0) # yaw
      glRotatef(@orientation.x, 0, 0, 1) # roll

      glCallList(@list_id)
      glPopMatrix
    end
  end

  def drawable?
    @drawable
  end

  def update
    @behavior.update if @behavior
  end
end