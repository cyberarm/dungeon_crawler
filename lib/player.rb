class Player
  Vector = Struct.new(:x, :y, :z, :weight)

  attr_accessor :position
  def initialize
    @position = Vector.new
  end

  def forward
  end

  def backward
  end

  def turn_left
  end

  def turn_right
  end
end