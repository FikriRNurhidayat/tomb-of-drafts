class Snake
  attr_accessor :bodies, :direction

  def initialize
    self.bodies = [{
      :x => 1, 
      :y => 1
    }] 

    self.direction = 'left'
  end

  def draw
    bodies.each do |segment|
      Image.new('./assets/01-SNAKE.png',
        x: segment[:x] * GRID,
        y: segment[:y] * GRID,
        width: GRID - 2,
        height: GRID - 2
      )
    end
  end

  def move
    case direction
    when 'left'
      bodies.push({
        :x => head[:x] - 1,
        :y => head[:y]
      })
      bodies.shift
    when 'right'
      bodies.push({
        :x => head[:x] + 1,
        :y => head[:y]
      })
      bodies.shift
    when 'up'
      bodies.push({
        :x => head[:x],
        :y => head[:y] - 1
      })
      bodies.shift
    when 'down'
      bodies.push({
        :x => head[:x],
        :y => head[:y] + 1
      })
      bodies.shift
    end
  end

  def warp
    i = bodies.length - 1
    while i >= 0 do
      if bodies[i][:x] >= (WIDTH / GRID) - 5
        bodies[i][:x] = 0
      elsif bodies[i][:x] < 0
        bodies[i][:x] = (WIDTH / GRID) - 5
      elsif bodies[i][:y] < 0
        bodies[i][:y] = (HEIGHT / GRID)
      elsif bodies[i][:y] >= (HEIGHT / GRID)
        bodies[i][:y] = 0
      end
      i = i - 1
    end
  end

  def eat(food)
    return unless head[:x] == food.x && head[:y] == food.y
    food.reset(bodies)
    bodies.unshift({
      :x => bodies.first[:x],
      :y => bodies.first[:y]
    })
  end

  def valid?(dir)
    case self.direction
    when 'up' then dir != 'down'
    when 'down' then dir != 'up'
    when 'left' then dir != 'right'
    when 'right' then dir != 'left'
    end
  end

  def death
    main = [head]
    body = []
    intersection = []
    
    if bodies.length > 2
      body = bodies[0...(bodies.length - 1)]
      intersection = body - main
    end

    return intersection.length != body.length
  end

  private

  def head
    return bodies[bodies.length - 1]
  end
end
