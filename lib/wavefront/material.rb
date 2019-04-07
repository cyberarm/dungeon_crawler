class Wavefront
  class Material
    attr_accessor :name, :ambient, :diffuse, :specular
    attr_reader :texture
    def initialize(name)
      @name    = name
      @ambient = GLColor.new(1, 1, 1, 1)
      @diffuse = GLColor.new(1, 1, 1, 1)
      @specular= GLColor.new(1, 1, 1, 1)
      @texture = nil
    end

    def set_texture(texture)
      @texture = Texture.get(File.basename(texture).split(".").first)
    end
  end
end