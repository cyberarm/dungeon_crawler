class MapBuilder < State
  def setup
    @tile_size = 16.0
    @map_width  = (@window.width  / @tile_size).floor
    @map_height = (@window.height / @tile_size).floor
    @map_tunnels= rand(1..512)
    @map_tunnel_max_length = rand(1..12)

    @map = Map.new(width: @map_width, height: @map_height, tunnels: @map_tunnels, max_length: @map_tunnel_max_length, size: @tile_size.floor)
    unless ARGV.first.end_with?(".txt")
      @map.build
    else
      load_map(File.expand_path("./../")+"/"+ARGV.first)
    end

    @font = Gosu::Font.new(18)
  end

  def needs_cursor?
    true
  end

  def draw
    @map.draw
    Gosu.draw_rect(@map.position[0] * @map.size, @map.position[1] * @map.size, @map.size, @map.size, Gosu::Color::GREEN)

    @font.draw_text("Generate #{@map_tunnels} tunnels of max length #{@map_tunnel_max_length}", 10, 10, 0)
    @font.draw_text("Press ENTER to Play\nPress F5 to regenerate map\nPress J|K to change number of tunnels\nPress F|G to change max tunnel length", 10, 28, 0)

  end

  def update
    @map.update

    if button_down?(Gosu::KbJ)
      @map_tunnels-=1
      @map_tunnels = 1 if @map_tunnels < 2
    end
    if button_down?(Gosu::KbK)
      @map_tunnels+=1
      @map_tunnels = 1024 if @map_tunnels > 1024
    end

    if button_down?(Gosu::KbF)
      @map_tunnel_max_length-=1
      @map_tunnel_max_length = 1 if @map_tunnel_max_length < 2
    end
    if button_down?(Gosu::KbG)
      @map_tunnel_max_length+=1
      @map_tunnel_max_length = 128 if @map_tunnel_max_length > 128
    end
  end

  def button_up(id)
    if id == Gosu::KbF5
      @map = Map.new(width: @map_width, height: @map_height, tunnels: @map_tunnels, max_length: @map_tunnel_max_length, size: @tile_size.floor)
      @map.build
    elsif id == Gosu::KbReturn || id == Gosu::KbEnter
      @window.state = MapPlayer.new(map: @map, window: @window)
    end
  end

  def button_down(id)
    if id == Gosu::KbS && (Gosu.button_down?(Gosu::KbLeftControl) || Gosu.button_down?(Gosu::KbRightControl))
      save_map
    end
  end

  def save_map
    puts "Saving..."
    buffer = ""

    @map.height.times do |y|
      @map.width.times do |x|
        if @map.tiles[x][y].type == :wall
          buffer+="#"
        else
          buffer+="-"
        end
      end
      buffer+="\n"
    end

    File.open("../data/map_#{Time.now.to_i}.txt", "w") {|f| f.write(buffer) }
    puts "Saved."
  end

  def load_map(file)
    mapfile = File.read(file)
    tiles = {}

    y = 0
    x = 0
    width = 0
    mapfile.each_line do |line|
      line.strip.each_char do |char|
        tiles[x] ||= {}

        if char == "#" # WALL
          tiles[x][y] = Map::Tile.new(:wall, @map.wall_color)
        else# FLOOR '-'
          tiles[x][y] = Map::Tile.new(:floor, @map.floor_color)
        end

        x +=1
      end

      y += 1
      x = 0
      width = line.strip.length
    end

    @map = Map.new(width: width, height: y, tunnels: 0, max_length: 0, size: 16.0)
    tiles.each do |_x, hash|
      hash.each do |_y, tile|
        @map.tiles[_x] ||= {}
        @map.tiles[_x][_y] = tile
      end
    end

    puts "Loaded #{file}."
  end

  def drop(file)
    load_map(file)
  end

  def normalize(n)
    (n / @tile_size).floor
  end
end