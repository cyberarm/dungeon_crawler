class Planter < Thing
  def construct!
    @collidable = false
  end

  def setup
    @faces = Wavefront::Model.new(:potted_tree).faces
  end
end