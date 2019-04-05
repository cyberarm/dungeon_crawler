class Texture
  include OpenGL
  def initialize(name, texture_path)
    @texture = Gosu::Image.new("#{GAME_ROOT_PATH}/#{texture_path}", retro: true)
    array_of_pixels = @texture.to_blob

    tex_names_buf = ' ' * 8
    glGenTextures(1, tex_names_buf)
    @texture_id = tex_names_buf.unpack('L2').first

    glBindTexture(GL_TEXTURE_2D, @texture_id)
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, @texture.width, @texture.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, array_of_pixels)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
    glGenerateMipmap(GL_TEXTURE_2D)

    @texture = nil

    Texture.set(name, id)
  end

  def id
    @texture_id
  end

  def self.get(key)
    setup
    t = @textures.dig(key)
    t ||= @textures[:missing]
  end

  def self.set(key, id)
    setup
    @textures[key] = id
  end

  def self.all
    setup
    @textures.map {|key, value| value }
  end

  def self.setup
    return if @textures

    @textures ||= {}
    Texture.new(:missing, "assets/default.png")
  end
end