#! /usr/bin/env lua

local push = require 'push'

local VIRTUAL_WIDTH,  VIRTUAL_HEIGHT = 640, 480  --  fixed game resolution
local windowWidth, windowHeight = love .window .getDesktopDimensions()

windowWidth,  windowHeight = windowWidth *0.7,  windowHeight *0.7  --  make window a bit smaller than the screen itself
push :setupScreen(  VIRTUAL_WIDTH,  VIRTUAL_HEIGHT,  windowWidth,  windowHeight,  {fullscreen = false}  )

HALF_WIDTH = VIRTUAL_WIDTH /2
HALF_HEIGHT = VIRTUAL_HEIGHT /2

wrongCount = 0
randomWord = 'word'
wordSpots = {}
for i = 1, #randomWord do wordSpots[ #wordSpots +1 ] = '' end
wordList = {}
numBlanks = string .len( randomWord )
Ltext = ' '
correctguess = ''

function love .keypressed( key, scancode, isrepeat )
    ASCII = string .byte( key )  --  print( ASCII )
    if key == 'escape' then  love .event .quit()

               --  UPPERCASE LETTERS        or        lowercase letters      ASCII-code.com
    elseif ( ASCII >= 65 and ASCII <= 90 ) or ( ASCII >= 97 and ASCII <= 122 ) then
        --  guess function
        Ltext = string .lower( key )  --  ensure no problems with capitalization
        LrandomWord = string .lower( randomWord )  --  ditto
        letterWrong = 0

        for i = 1,  #LrandomWord do
            c = LrandomWord :sub( i, i )
            if Ltext == c then
                correctguess = Ltext
                wordSpots[i] = correctguess
            else
                letterWrong = letterWrong +1
            end
        end  --  #LrandomWord

        if letterWrong == #LrandomWord then
            wrongCount = wrongCount +1
        end
    end
end  --  love .keypressed()


function love .draw()
    push :apply( 'start' )
    love .graphics .clear( 40/255,  45/255,  52/255 )
    love .graphics .printf( 'Welcome to Hardcore Hangman!',  0,  10,  VIRTUAL_WIDTH,  'center' )

    --  draw hanging pole
    love .graphics .setColor( 150/255,  150/255,  150/255 )
    love .graphics .rectangle( 'fill',  HALF_WIDTH -80,  HALF_HEIGHT +40,  160,  5 )  --  base

    love .graphics .setColor( 220/255,  220/255,  220/255 )
    love .graphics .rectangle( 'fill',  HALF_WIDTH -60,  HALF_HEIGHT -80,  5,  120 )  --  pole
    love .graphics .rectangle( 'fill',  HALF_WIDTH -60,  HALF_HEIGHT -80,  45,  5 )  --  upper base
    love .graphics .rectangle( 'fill',  HALF_WIDTH -15,  HALF_HEIGHT -80,  5,  15 )  --  small down pole

    love .graphics .setColor( 90/255,  90/255,  90/255 )
    for i = 1, wrongCount do  --  draw rope
        love .graphics .rectangle( 'fill',  HALF_WIDTH -4,  HALF_HEIGHT -60 +(i-1) *15 , 20, 5 )
    end

    blankPos = VIRTUAL_WIDTH /6
    for i = 1, #randomWord do  --  creates blanks for guessing
        love .graphics .rectangle( 'fill',  blankPos +(i-1) *35,  HALF_HEIGHT +90,  25,  5 )
    end

    if correctguess == Ltext then
        love .graphics .setColor( 220/255,  90/255,  90/255 )  --  correct guess highlights letter
        love .graphics .print( correctguess,  HALF_WIDTH -2,  78,  0,  3.5,  3.5 )
    end

    love .graphics .setColor( 200/255,  200/255,  200/255 )  --  lowercase guess
    love .graphics .print( Ltext,  HALF_WIDTH,  80,  0,  3,  3 )

    love .graphics .setColor( 200/255,  200/255,  200/255 )  --  word so far
    for i = 1, #wordSpots do
        love .graphics .print( wordSpots[i],  blankPos +(i-1) *35 +3,  HALF_HEIGHT +60,  0,  2,  2 )
    end

    push :apply( 'end' )
end  --  love .draw()

