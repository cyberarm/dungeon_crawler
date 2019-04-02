class Map
  Tile = Struct.new(:type, :color)

  attr_reader :tiles, :width, :height, :position
  def initialize(width:, height:, tunnels:, max_length:, size: 16)
    @width, @height = width, height
    @tunnels, @max_length = tunnels, max_length
    @size = size

    @steps_per_update = 60

    @max_tunnels = @tunnels

    @tiles = {}

    @last_step_time = Gosu.milliseconds
    @time_between = 0

    @directions = [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]

    @current_direction = @directions.sample
    @current_walk_distance = rand(1..@max_length)
    @position = [@width/2, @height/2]

    build
  end

  def build
    @height.times do |y|
      @width.times do |x|
        @tiles[x] ||= {}
        @tiles[x][y] = Tile.new(:wall, wall_color)
      end
    end
  end

  def draw(font)
    @height.times do |y|
      @width.times do |x|
        Gosu.draw_rect(x * @size, y * @size, @size, @size, @tiles[x][y].color)
      end
    end

    Gosu.draw_rect(@position[0] * @size, @position[1] * @size, @size, @size, Gosu::Color::GREEN)

    font.draw_text("Tunnels: #{@max_tunnels-@tunnels}/#{@max_tunnels}, Max Tunnel Length: #{@max_length}", 10, 75, 0)
    font.draw_text("Walker: Position: #{@position}, Direction: #{@current_direction}, Distance Left: #{@current_walk_distance}", 10, 75+20, 0)
  end

  def update
    if Gosu.milliseconds >= @last_step_time + @time_between
      @last_step_time = Gosu.milliseconds

      @steps_per_update.times { walk }
    end
  end

  def walk
    return if @tunnels <= 0


    if @current_walk_distance <= 0
      @current_direction = (@directions.reject {|d| d == @current_direction || d == [@current_direction[0] * -1, @current_direction[1] * -1]}).sample
      @current_walk_distance = rand(1..@max_length)

      @tunnels-=1
    end

    @current_walk_distance-=1

    @position[0] = @position[0] + @current_direction[0]
    @position[1] = @position[1] + @current_direction[1]

    @current_direction[0] = 1 if @position[0] <= 2 && @current_direction[0] == -1
    @current_direction[0] = -1 if @position[0] >= @width-3 && @current_direction[0] == 1

    @current_direction[1] = 1 if @position[1] <= 2 && @current_direction[1] == -1
    @current_direction[1] = -1 if @position[1] >= @height-3 && @current_direction[1] == 1

    begin
      @tiles[@position[0]][@position[1]] = Tile.new(:floor, floor_color)
    rescue NoMethodError
      puts "Walking: #{@current_direction} -> #{@position} | T:#{@tunnels}/#{@max_tunnels}, W:#{@current_walk_distance}"
      p @position
      raise
    end
  end

  def wall_color(base_color = Gosu::Color.rgb(50, 50, 50), drift = 3)
    tweak_color(base_color, drift)
  end

  def floor_color(base_color = Gosu::Color.rgb(100, 75, 0), drift = 10)
    tweak_color(base_color, drift)
  end

  def tweak_color(base_color, drift)
    base_color.red = base_color.red + rand(-drift/2..drift/2)
    base_color.green = base_color.green + rand(-drift/2..drift/2)
    base_color.blue = base_color.blue + rand(-drift/2..drift/2)

    base_color
  end
end