class State
  def initialize(options = {})
    @options = options
    @window  = options[:window]
    @show_cursor = false

    setup
  end

  def setup
  end

  def draw
  end

  def update
  end

  def needs_cursor?
    @show_cursor
  end

  def button_down(id)
  end

  def button_up(id)
  end
end