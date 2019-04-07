class Level
  include OpenGL

  def initialize(options = {})
    @options = options
    @window = options[:window]
    @map = options[:map]

    @list_id = glGenLists(1)
    @list_filled = false

    Shader.new(name: :default, fragment: "shaders/default.frag")

    @mesh = Mesh.new(map: @map)
  end

  def draw
    glEnable(GL_CULL_FACE)
    glCullFace(GL_BACK)

    Shader.use(:default)
    Shader.set_uniform("in_Time", Gosu.milliseconds)

    unless @list_filled
      @list_filled = true

      glNewList(@list_id, GL_COMPILE)
        render
      glEndList
    else
      glCallList(@list_id)
    end

    Shader.stop
  end

  def render
    Texture.all.each do |texture|
      if texture
        glEnable(GL_TEXTURE_2D)
        glBindTexture(GL_TEXTURE_2D, texture)
        Shader.set_uniform("in_NoTexture", 0.0)
      else
        Shader.set_uniform("in_NoTexture", 1.0)
      end

      glBegin(GL_TRIANGLES)
        @mesh.faces.select {|f| f.texture == texture}.each do |face|
          face.draw
        end
      glEnd

      @window.handle_gl_error
      glDisable(GL_TEXTURE_2D) if texture
    end
  end
end