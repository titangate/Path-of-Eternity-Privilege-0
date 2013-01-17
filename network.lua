local socket = require 'socket'

local master = socket.tcp()
local client = socket.connect('xthexder.info',12345)

function getFood(food)
    print (food,'being delievered')
    client:send(string.format('getFood %s\n',food))
end

function returnToStart()
    client:send'returnToStart\n'
end