require './objects/snake'
require './objects/home'
require './objects/food'

GAME = false
GRID = 32
WIDTH = get :width
HEIGHT = get :height
AVAILABLE_GRID = (HEIGHT/GRID) - 1
ARR_GRID = []

int = 0

while int <= AVAILABLE_GRID do
  ARR_GRID.push(int)
  int += 1
end

snake = Snake.new
food = Food.new
home = Home.new

update do
  clear

  if GAME
    unless snake.death
      snake.move
      snake.warp
      snake.eat(food)

      snake.draw
      food.draw
    else
      snake.bodies = [{
        :x => 5,
        :y => 5
      }]
      GAME = false
    end
  else
    home.draw
  end
end

on :key do |event|
  case event.key
  when 'escape'
    close
  when 'space'
    GAME = true
  end

  if snake.valid?(event.key)
    snake.direction = event.key if ['up', 'down', 'left', 'right'].include?(event.key) 
  end
end
