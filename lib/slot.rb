class Map
  class Slot
    attr_reader :voxel, :thing
    def initialize(voxel = nil, thing = nil)
      @voxel = voxel
      @thing = thing
    end

    def voxel=(_voxel)
      raise ArgumentError, "Slot must always have a Voxel" if _voxel.nil?
      raise ArgumentError, "Must be a Voxel" unless _voxel.is_a?(Voxel)
      @voxel = _voxel
    end

    def thing=(_thing)
      raise ArgumentError, "Must be a Thing" unless _thing.is_a?(Thing) || _thing.nil?
      @thing = _thing
    end

    def collidable?
      (@voxel && @voxel.collidable?) || (@thing && @thing.collidable?)
    end
  end
end