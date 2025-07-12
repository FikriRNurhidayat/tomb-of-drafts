class Home
  def draw
    Text.new(
      "Pencet 'spasi' untuk makar!",
      :x => WIDTH / 4.5, :y => HEIGHT / 2,
      size: 16,
      z: 100
    )

    Image.new(
      "./assets/03-BACKGROUND.png",
      :x => 0, :y => 0,
      width: 480,
      height: 480,
      z: 0
    )
  end
end
