class Wavefront
  class ModelObject
    attr_reader :name
    attr_accessor :faces
    def initialize(name)
      @name = name
      @faces = []
    end
  end
end