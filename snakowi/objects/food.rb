class Food
  attr_accessor :x, :y

  def initialize
    self.x = rand(0..AVAILABLE_GRID)
    self.y = rand(0..AVAILABLE_GRID)
  end

  def draw
    Image.new(
      './assets/02-COIN.png',
      x: x * GRID,
      y: y * GRID,
      width: GRID,
      height: GRID
    )
  end

  def reset(bodies) 
    not_x = []
    not_y = []

    bodies.each do |body|
      not_x.push(body[:x])
      not_y.push(body[:y])
    end

    self.x = (ARR_GRID - not_x).sample
    self.y = (ARR_GRID - not_y).sample
  end
end
