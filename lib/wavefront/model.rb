class Wavefront
  class Model
    def initialize(name = :default)
      @name = name
      @objects = []

      unless File.exist?("#{GAME_ROOT_PATH}/assets/models/#{name}/#{name}.obj")
        warn "Model '#{name.inspect}' not found, using fallback."
        name = :default
      end

      @parser = Parser.new("#{GAME_ROOT_PATH}/assets/models/#{name}/#{name}.obj")
    end

    def faces
      @parser.faces
    end
  end
end