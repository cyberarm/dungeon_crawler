class Planter < Thing
  def construct!
    @collidable = true
  end

  def setup
    @faces = Wavefront::Model.new(:potted_tree).faces
  end
end