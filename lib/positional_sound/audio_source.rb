class PositionalAudio
  class AudioSource
    attr_reader :sound, :channel, :started_playing_at
    attr_accessor :volume, :speed, :pan
    attr_accessor :entity, :position

    def initialize(sound:, max_volume: 1.0, volume: 1.0, speed: 1.0, pan: 0.0, entity: nil, position: nil)
      @channel = nil
      @sound = Gosu::Sample.new(sound)

      @max_volume = max_volume

      @volume= volume
      @speed = speed
      @pan   = pan

      @entity = entity
      @position = position

      @started_playing_at = Gosu.milliseconds

      raise ArgumentError, "position or entity must be provided" if entity.nil? && position.nil?
    end

    def update
      @position = entity.position if @entity

      if @channel
        @channel.volume = @volume.clamp(0.0, @max_volume)
        @channel.speed  = @speed
        @channel.pan    = @pan
      end
    end

    def play
      @started_playing_at = Gosu.milliseconds
      @channel = @sound.play(@volume, @speed, false)
    end

    def playing?
      @channel && @sound.playing?
    end

    def stop
      @sound.stop
      @channel = nil
    end
  end
end