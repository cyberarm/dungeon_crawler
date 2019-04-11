class SlidingDoor < Thing
  def setup
    @faces = Wavefront::Model.new(:demon).faces
    @behavior = SlidingDoorBehavior.new(self)
  end

  def construct!
    @collidable = true

    case @options[:form]
    when :left_to_right
    when :front_to_back
      rotate_y!(-90)
    end
  end
end