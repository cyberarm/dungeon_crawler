class Wavefront
  class Model
    def initialize(name = "default")
      @name = name
      @objects = []

      @parser = Parser.new("#{GAME_ROOT_PATH}/assets/models/#{name}/#{name}.obj")
    end

    def faces
      @parser.faces
    end
  end
end