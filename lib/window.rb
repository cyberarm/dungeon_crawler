class Window < Gosu::Window
  include OpenGL
  include GLU

  def initialize
    super(1280, 600, fullscreen: false, resizable: false)
    # super(Gosu.screen_width, Gosu.screen_height, true)
    Window.instance = self

    self.caption = "Dungeon Crawler"
    @current_state = MapBuilder.new(window: self)
    @delta_time = Gosu.milliseconds
    @screenshot = false
  end

  def delta
    (Gosu.milliseconds - @delta_time) / 1000.0
  end

  def draw
    if @screenshot
      @screenshot = false
      Gosu.render(self.width, self.height) do
        @current_state.draw
      end.save("screenshot-#{Time.now.to_i}.png")
    end

    @current_state.draw
  end

  def update
    @current_state.update
    @delta_time = Gosu.milliseconds
  end

  def state=(state)
    @current_state = state
  end

  def needs_cursor?
    @current_state.needs_cursor?
  end

  def button_down(id)
    super
    @current_state.button_down(id)
  end

  def button_up(id)
    super
    @screenshot = true if id == Gosu::KbF12
    @current_state.button_up(id)
  end

  def drop(file)
    @current_state.drop(file)
  end

  def handle_gl_error
    e = glGetError()
    if e != GL_NO_ERROR
      $stderr.puts "OpenGL error in: #{gluErrorString(e)} (#{e})\n"
      exit
    end
  end

  def self.instance
    @instance
  end

  def self.instance=(inst)
    raise ArgumentError, "Must be an instance of Window!" unless inst.is_a?(Window)
    @instance = inst
  end

  def self.handle_gl_error
    Window.instance.handle_gl_error
  end
end