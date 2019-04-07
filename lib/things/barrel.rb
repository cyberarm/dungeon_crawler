class Barrel < Thing
  def construct!
    @collidable = false
  end

  def setup
    position_vector = Vector.new(@x + 0.5, 0, @y + 0.5)

    @faces = Wavefront::Model.new(:barrel).faces
    @faces.each do |face|
      face.vertices.each_with_index do |vector, i|
        face.vertices[i] = vector + position_vector
      end
    end
  end
end