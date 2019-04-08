class RisingDoor < Thing
  def construct!
    @collidable = true
  end

  def setup
    @faces = Wavefront::Model.new(:door).faces
    case @options[:form]
    when :left_to_right
    when :front_to_back
      @orientation.y = 90
    end

    @behavior = RisingDoorBehavior.new(self)
  end
end