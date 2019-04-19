class CollisionManager
  Entity = Struct.new(:entity, :bounding_box)
  Collision = Struct.new(:ent_a, :ent_b)

  attr_reader :collisions, :entities
  def initialize(map)
    @map = map
    @collisions = []
    @entities = []

    @min_wall_distance = 0.2
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
    if @collisions.size > 0
      puts "#{@collisions.count} collisions detected!"

      @collisions.each do |collision|
        puts "#{collision.ent_a.entity.class}|#{collision.ent_a.entity.object_id} collided with #{collision.ent_b.entity.class}|#{collision.ent_b.entity.object_id}"
      end

      puts
    end
  end

  # returns an array of entities the ray collides with
  def ray_intersect(ray)
    @entities.select do |ent|
      next if ent.entity == self
      next unless ent.bounding_box

      ray.intersect?(ent.bounding_box)
    end
  end

  def move_thing(thing, speed, direction)
    speed = speed * Window.instance.delta

    x_slot = @map.grid.dig((thing.position.x + direction.x * speed + (direction.x * @min_wall_distance)).to_i, thing.position.z.to_i)
    z_slot = @map.grid.dig(thing.position.x.to_i, (thing.position.z + direction.z * speed + (direction.z * @min_wall_distance)).to_i)

    nx = Vector.new(direction.x)
    ny = Vector.new(0, direction.y, 0)
    nz = Vector.new(0, 0, direction.z)

    permitted_movement = {x: false, y: false, z: false}

    if (x_slot && !x_slot.collidable?) && (z_slot && !z_slot.collidable?)
      permitted_movement.keys.each {|k| permitted_movement[k] = true}
    elsif (x_slot && !x_slot.collidable?)
      permitted_movement[:x] = true
    elsif (z_slot && !z_slot.collidable?)
      permitted_movement[:z] = true
    end

    @entities.each do |entity|
      next if entity.entity == thing

      if thing.bounding_box.transpose(thing.position + (direction * speed)).intersect?(entity.bounding_box)
        permitted_movement[:x] = !thing.bounding_box.transpose(thing.position + (nx * speed)).intersect?(entity.bounding_box)
        permitted_movement[:y] = !thing.bounding_box.transpose(thing.position + (ny * speed)).intersect?(entity.bounding_box)
        permitted_movement[:z] = !thing.bounding_box.transpose(thing.position + (nz * speed)).intersect?(entity.bounding_box)
      end
    end

    permitted_movement.each do |axis, allowed|
      thing.position += nx * speed if axis == :x && allowed
      thing.position += ny * speed if axis == :y && allowed
      thing.position += nz * speed if axis == :z && allowed
    end

    return permitted_movement.values.any?(true)
  end
end