class Barrel < Thing
  def construct!
    @collidable = false
  end

  def setup
    @faces = Wavefront::Model.new(:barrel).faces
    # @behavior = WanderBehavior.new(self)
  end
end