class PositionalAudio
  class Listener
    attr_accessor :entity, :position
    attr_reader :sources
    def initialize(entity: nil, position: nil, range: 15)
      @entity = entity
      @position = position
      @range   = range
      @sources = []

      raise ArgumentError, "position or entity must be provided" if entity.nil? && position.nil?
    end

    def update
      @position = @entity.position if @entity

      @sources.each do |source|
        source.update
        localize_source(source)
      end
    end

    def add_source(source)
      @sources << source
      source.play
    end

    def localize_source(source)
      dist = @position.distance3d(source.position)
      if dist <= @range
        volume = ((dist / @range.to_f) - 1).abs
        source.volume = volume

        if dist <= 0.25
          source.pan = 0.0
          return
        end

        angle = @position.angle(source.position)
        _angle = (((angle - @entity.orientation.y) + 90) % 359).round(2) # Make an arc from left 0 to right 180 for front

        source.pan = rand(-10.0..10.0)
        if _angle.between?(0, 180) # source is in front of listener
          if _angle <= 90
            pan = (((-_angle / 90.to_f) + 1) * -1) * 0.00000005
            source.pan =  pan
          else
            pan = (((-_angle / 90.to_f) + 1) * -1) * 0.00000005
            source.pan =  pan
          end
        else # source is behind listener
          # tweak speed to make it 'feel' behind?
          _angle -= 180
          if _angle <= 90
            pan = ((-_angle / 90.to_f) + 1) * 0.00000005
            source.pan =  pan
          else
            pan = ((-_angle / 90.to_f) + 1) * 0.00000005
            source.pan =  pan
          end
        end

      else # Out of range
        source.volume = 0
      end
    end
  end
end