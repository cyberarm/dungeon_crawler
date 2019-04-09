class RisingDoor < Thing
  def construct!
    @collidable = true

    case @options[:form]
    when :left_to_right
    when :front_to_back
      @orientation.y = 90
      # rotate_y(90) # rotate vertices around the y axis
    end
  end

  def setup
    @faces = Wavefront::Model.new(:door).faces
    @behavior = RisingDoorBehavior.new(self)
  end
end