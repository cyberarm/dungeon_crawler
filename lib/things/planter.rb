class Planter < Thing
  def construct!
    @collidable = true
  end

  def setup
    @faces = Wavefront::Model.new(:potted_tree).faces

    # audio
    @bumblebee_sound = PositionalAudio::AudioSource.new(sound: GAME_ROOT_PATH + "/assets/sounds/bumblebee.wav", entity: self)
    @bumblebee_interval_range = 10_000..60_000
    @bumblebee_interval = rand(@bumblebee_interval_range)
  end

  def update
    super

    if (Gosu.milliseconds - @bumblebee_sound.started_playing_at) >= @bumblebee_interval
      @bumblebee_interval = rand(@bumblebee_interval_range)
      @map.positional_audio.add_source(@bumblebee_sound)
    end
  end
end