local component     = require("component")
local event         = require("event")
local serialization = require("serialization")
local filesystem    = require("filesystem")
local m = component.modem

m.setStrength(16)
m.broadcast(244, nil, "addRobot", nil)