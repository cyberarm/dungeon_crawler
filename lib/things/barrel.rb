class Barrel < Thing
  def construct!
    @collidable = false
  end

  def setup
    @faces = Wavefront::Model.new(:barrel).faces
  end
end