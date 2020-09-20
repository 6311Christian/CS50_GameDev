-- CS50' Introduction to Computer Science
-- Final Project: Defender !

-- Import libraries
Class = require 'class'
push = require 'push'

require 'Ball'
require 'Player'

-- Define Variables
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
player = Player(VIRTUAL_WIDTH / 2 - 20, VIRTUAL_HEIGHT - 10, 40, 3)

playerScore = 0

PLAYER_SPEED = 200

gameState = 'start'

-- Load the game
function love.load()

    math.randomseed(os.time())
    
    -- Set Title text
    love.window.setTitle('CS50 Intro to CS: Final Projec: Defender!')
    -- Screen Size Settings
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
    {fullscreen = false, vsync = true, resizable = true})
    -- SettingUp sound effects
    sounds = {['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/music.wav', 'static')}

    gameState = 'start'

end

-- Title Text
function love.draw()

    push:apply('start')

    -- Background color
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    -- Setting the fonts
    smallFont = love.graphics.newFont('font.TTF', 8)
    scoreFont = love.graphics.newFont('font.TTF', 24)
    overFont = love.graphics.newFont('font.TTF', 24)
    -- Setting the game texts
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome to Defender!", 0, VIRTUAL_HEIGHT / 2 - 70, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press ENTER to PLAY", 0, VIRTUAL_HEIGHT / 2 - 60, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        ball:render()
        player:render()
        love.graphics.setFont(scoreFont)
        love.graphics.print(playerScore, VIRTUAL_WIDTH / 2 - 12, VIRTUAL_HEIGHT / 2 - 60)
        love.graphics.rectangle('fill', 5, VIRTUAL_HEIGHT - 3, VIRTUAL_WIDTH - 10, 1)
    elseif gameState == 'done' then
        love.graphics.setFont(scoreFont)
        love.graphics.print(playerScore, VIRTUAL_WIDTH / 2 - 12, VIRTUAL_HEIGHT / 2 - 60)
        love.graphics.setFont(overFont)
        love.graphics.printf("Game Over !", 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
    end
    
    push:apply('end')

end

-- Start and Quit
function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            playerScore = 0
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'
        elseif gameState == 'done' then
            gameState = 'start'

            ball:reset()

        end
    end

end

function love.update(dt)

    player:update(dt)

    sounds['music']:setLooping(true)
    sounds['music']:setVolume(0.05)
    sounds['music']:play()

    -- Moving the PLAYER with limits
    if love.keyboard.isDown('left') then
        player.dx = -PLAYER_SPEED
    elseif love.keyboard.isDown('right') then
        player.dx = PLAYER_SPEED
    else
        player.dx = 0
    end
    -- Moving the BALL
    if gameState == 'play' then
        ball.x = ball.x + ball.dx * dt
        ball.y = ball.y + ball.dy * dt
    end
    -- Colliding the ball with PLAYER
    if ball:collides(player) then
        ball.dy = -ball.dy * 1.25
        ball.y = player.y - 4
        playerScore = playerScore + 1
        sounds['paddle_hit']:play()
        sounds['paddle_hit']:setVolume(0.5)
    end
    -- Collides the ball with TOP
    if ball.y <= 0 then
        ball.dy = -ball.dy
        ball.y = ball.y + 4
        sounds['wall_hit']:play()
        sounds['wall_hit']:setVolume(0.5)
    end
    -- Collides the ball with LEFT
    if ball.x <= 0 then
        ball.dx = -ball.dx
        ball.x = ball.x + 4
        sounds['wall_hit']:play()
        sounds['wall_hit']:setVolume(0.5)
    end
    -- Collides the ball with RIGHT
    if ball.x >= VIRTUAL_WIDTH then
        ball.dx = -ball.dx
        ball.x = ball.x - 4
        sounds['wall_hit']:play()
        sounds['wall_hit']:setVolume(0.5)
    end
    -- Game Over !
    if ball.y > VIRTUAL_HEIGHT then
        sounds['score']:play()
        sounds['score']:setVolume(0.5)
        ball:reset()
        gameState = 'done'
    end
end