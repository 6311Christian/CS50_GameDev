--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score

    self.goldMedal = love.graphics.newImage('medal_gold.png')
    self.silverMedal = love.graphics.newImage('medal_silver.png')
    self.bronzeMedal = love.graphics.newImage('medal_bronze.png')
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    local receivedMedal = nil
    local medalType = nil
    if self.score >= 3 then
        receivedMedal = self.goldMedal
        medalType = 'gold'
    elseif self.score >= 2 then
        receivedMedal = self.silverMedal
        medalType = 'silver'
    elseif self.score >= 1 then
        receivedMedal = self.bronzeMedal
        medalType = 'bronze'
    end

    if receivedMedal ~= nil then
        love.graphics.printf('Congratulations! You received a ' .. medalType .. ' medal!', 0, 90, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(receivedMedal, VIRTUAL_WIDTH / 2 - receivedMedal:getWidth() / 2, 120)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 210, VIRTUAL_WIDTH, 'center')
end