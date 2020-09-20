-- Import libraries
Class = require 'class'
push = require 'push' -- https://github.com/Ulydev/push (push.lua)

require 'Ball'
require 'Paddle'

-- Define Variables
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)
player1 = Paddle(5, 20, 5, 20)
player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

player1Score = 0
player2Score = 0

servingPlayer = 1
winningPlayer = 0

PADDLE_SPEED = 200
AI_PADDLE_SPEED = 85

-- Load the game
function love.load()

    math.randomseed(os.time())
    
    -- Set Title text
    love.window.setTitle('CS50 Pong')
    -- Screen Size Settings
    love.graphics.setDefaultFilter('nearest', 'nearest') -- Graphics filter
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
    {fullscreen = false, vsync = true, resizable = true})
    -- SettingUp sound effects
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }
    gameState = 'start'

end

-- Resizeble screen function
function love.resize(w, h)
    push:resize(w, h)
end

-- Title Text
function love.draw()
    
    push:apply('start')

    -- Background color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    -- Setting the fonts
    smallFont = love.graphics.newFont('font.TTF', 8)
    scoreFont = love.graphics.newFont('font.TTF', 32)
    victoryFont = love.graphics.newFont('font.TTF', 24)
    -- Score text (font + position)
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
    -- FPS text
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
    -- Draw the Ball
    ball:render()
    -- Draw the Paddles
    player1:render()
    player2:render()
    -- Setting the game texts
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome to Pong !", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press 1 or 2 set AI to PLAYER 1 or 2", 0, 32, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press ENTER to START !", 0, 44, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("PLayer " .. tostring(servingPlayer) .. "'s serve!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press ENTER to SERVE !", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf("PLayer " .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press ENTER to RESTART !", 0, 42, VIRTUAL_WIDTH, 'center')
    end

    push:apply('end')

end

-- Start and Quit
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'victory' then
            gameState = 'start'
            player1Score = 0
            player2Score = 0
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end
    if key == '1' then
        if player1.ai then
            player1.ai = false
        else
            player1.ai = true
        end
    end
    if key == '2' then
        if player2.ai then
            player2.ai = false
        else
            player2.ai = true
        end
    end
end

-- Gameplay
function love.update(dt)

        player1:update(dt)
        player2:update(dt)
        
    if gameState == 'play' then
        ball:update(dt)
    end
    -- Moving player 1 AI or HUMAN
    if player1.ai then 
        if player1:down(ball) then
            player1.dy = -AI_PADDLE_SPEED
        elseif player1:up(ball) then
            player1.dy = AI_PADDLE_SPEED  
        else
            player1.dy = 0
        end
    else
        if love.keyboard.isDown('w') then
            player1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            player1.dy = PADDLE_SPEED
        else
            player1.dy = 0
        end    
    end 
    -- Moving player 2 AI or HUMAN
    if player2.ai then
        if player2:down(ball) then
            player2.dy = -AI_PADDLE_SPEED
        elseif player2:up(ball) then
            player2.dy = AI_PADDLE_SPEED
        else
            player2.dy = 0
        end
    else   
        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0
        end
    end
    -- Colliding the ball with player 1
    if ball:collides(player1) then
        ball.dx = -ball.dx * 1.03
        ball.x = player1.x + 5
        sounds['paddle_hit']:play()
        -- set velocity
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end
    -- Colliding the ball with player 2
    if ball:collides(player2) then
        ball.dx = -ball.dx * 1.03
        ball.x = player2.x - 4
        sounds['paddle_hit']:play()
        -- set velocity
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end
    -- Collides the ball with top
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end
    -- Collides the ball with bottom
    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.y = VIRTUAL_HEIGHT - 4
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end
    -- Scoring player 1
    if ball.x < 0 then
        servingPlayer = 1
        player2Score = player2Score + 1
        sounds['score']:play()
        ball:reset()
        ball.dx = 100
        if player2Score >= 3 then
            gameState = 'victory'
            winningPlayer = 2
        else
            gameState = 'serve'
        end
    end
    -- Scoring player 2
    if ball.x > VIRTUAL_WIDTH - 4 then
        servingPlayer = 2
        player1Score = player1Score + 1
        sounds['score']:play()
        ball:reset()
        ball.dx = -100
        if player1Score >= 3 then
            gameState = 'victory'
            winningPlayer = 1
        else
            gameState = 'serve'
        end
    end
end