require("src.Game")

function love.load()
    game = Game.create()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end
