class Level
  include OpenGL

  def initialize(options = {})
    @options = options
    @window = options[:window]
    @map = options[:map]
    @tile_size = 1.0

    @list_id = glGenLists(1)
    @list_filled = false

    Texture.new("floor", "assets/floor.png")
    Texture.new("wall", "assets/wall.png")
    Texture.new("ceiling", "assets/ceiling.png")

    Shader.new(name: :default, fragment: "shaders/default.frag")

    @mesh = Mesh.new(map: @map)
  end

  def draw
    unless @list_filled
      @list_filled = true

      glNewList(@list_id, GL_COMPILE)
        Shader.use(:default)
        render
        Shader.stop
      glEndList
    else
      glCallList(@list_id)
    end
  end

  def render
    Texture.all.each do |texture|
      if texture
        glEnable(GL_TEXTURE_2D)
        glBindTexture(GL_TEXTURE_2D, texture)
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