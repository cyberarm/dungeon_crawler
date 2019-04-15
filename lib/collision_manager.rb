class CollisionManager
  Entity = Struct.new(:entity, :bounding_box)
  Collision = Struct.new(:ent_a, :ent_b)

  attr_reader :collisions, :entities
  def initialize(map)
    @map = map
    @collisions = []
    @entities = []
  end

  def update
    @entities.clear

    @map.things.each do |thing|
      @entities << Entity.new(thing, thing.bounding_box.transpose(thing.position))
    end
    @map.players.each do |player|
      @entities << Entity.new(player, player.bounding_box.transpose(player.position))
    end

    find_collisions
    handle_collisions
  end

  def find_collisions
    @collisions.clear

    @entities.each do |ent|
      @entities.each do |ent_b|
        next if ent == ent_b
        next if @collisions.detect {|c| c.ent_b == ent} # Prevent inverse duplicate collisions

        if ent.bounding_box.intersect?(ent_b.bounding_box)
          @collisions << Collision.new(ent, ent_b)
        end
      end
    end
  end

  def handle_collisions
    puts "#{@collisions.count} collisions detected!" if @collisions.size > 0
    @collisions.each do |collision|
      puts "#{collision.ent_a.entity.class} collided with #{collision.ent_b.entity.class}"
    end
    puts if @collisions.size > 0
  end
end