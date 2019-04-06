class Level
  class Mesh

    attr_reader :faces
    def initialize(map:)
      @map = map
      @faces = []

      process_map
      collect_faces
    end

    def process_map
      @map.height.times do |y|
        @map.width.times do |x|
          tile = @map.tiles[x][y]

          construct_slot(tile, x, y)
        end
      end
    end

    def construct_slot(tile, x, y)
      @map.grid[x] ||= {}
      slot = @map.grid[x][y] ||= Map::Slot.new

      case tile[:type]
      when :wall
        slot.voxel = Wall.new(@map, x, y)
      when :door_left_to_right
        slot.voxel = Door.new(@map, x, y, form: :left_to_right)
      when :door_front_to_back
        slot.voxel = Door.new(@map, x, y, form: :front_to_back)
      else# :floor
        slot.voxel = Floor.new(@map, x, y)
        slot.thing = nil#Barrel.new(@map, x, y)
      end
    end

    def collect_faces
      @map.height.times do |y|
        @map.width.times do |x|
          slot = @map.grid[x][y]

          @faces << slot.voxel.faces
        end
      end

      @faces.flatten!
    end
  end
end