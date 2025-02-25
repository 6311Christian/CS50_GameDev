Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = 100 --math.random(-300, 300)
    self.dy = 100 --math.random(-300, 300)
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:collides(box)
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    elseif self.y > box.y + box.height or self.y + self.height < box.y then
        return false
    else
        return true
    end
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = 40
    self.dx = 100 --math.random(-300, 300)
    self.dy = 100 --math.random(-300, 300)
end