class Barrel < Thing
  def construct!
    @collidable = true
  end

  def setup
    @faces = Wavefront::Model.new(:barrel).faces
    # @behavior = WanderBehavior.new(self)
  end
end