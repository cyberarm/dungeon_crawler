# Anything that is not a ceiling, floor, or wall is a thing.
# a Thing is a "billboards" which alway faces the player.
class Thing < Entity
  include OpenGL
  def initialize(map, x, y, options = {})
    super(map, x, y, options)

    @list_id = glGenLists(1)
    @list_filled = false
    @drawable = true
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
      glTranslatef(@x + 0.5, 0, @y + 0.5)
      glCallList(@list_id)
      glPopMatrix
    end
  end
end