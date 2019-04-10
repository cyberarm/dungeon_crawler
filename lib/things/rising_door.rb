class RisingDoor < Thing
  def setup
    @faces = Wavefront::Model.new(:door).faces
    @behavior = RisingDoorBehavior.new(self)
  end

  def construct!
    @collidable = true

    case @options[:form]
    when :left_to_right
    when :front_to_back
      rotate_y!(90)
    end
  end

  def update
    rotate_y!(0.1)
  end
end