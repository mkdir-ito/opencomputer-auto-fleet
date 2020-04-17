local component     = require("component")
local event         = require("event")
local term          = require("term")
local serialization = require("serialization")
local internet      = require("internet")
local keyboard      = require("keyboard")
local filesystem    = require("filesystem")
local thread        = require("thread")
local uuid          = require("uuid")
local m = component.modem
local g = component.gpu
local width, height = g.maxResolution()

local robots = {}

function modemMessage(_, receiverAddress, senderAddress, port, distance, from, command, serialData)
    if command == 'addRobot' then
        robots[from] = {name=string.sub(uuid.next(),1,4)}
    end
end
event.listen("modem_message", modemMessage)

function commandHandler(command)
    if command:find('^rename +%w +%w\n$') ~= nil then 
        orig, new = command:match('^rename (+%w) (+%w)\n$')
        for k,v in pairs(robots) do
            if v.name == orig then
                robots[k].name = new
            end
        end
    --elseif command:find() != nil then 
    else 
        --
    end
end
event.listen("command", commandHandler)

m.open(244)
m.setStrength(16)
function main()
    g.fill(1,1, width, height-3,  " ")
    g.set(1,1,'Robots: ')
    local row = 2
    for k,v in pairs(robots) do
        g.set(1,row,' --' .. v.name)
        row = row + 1
    end
end
local timer = event.timer(.25, main, math.huge)

local userThread = thread.create(function()
    while true do
        term.setCursor(1,height-1)
        term.clearLine()
        local command = term.read({nowrap=true})
        event.push("command", command)
    end
end)

function interruptHandler()
    userThread:suspend()
    event.cancel(timer)
    term.clear()
end
event.listen("interrupted", interruptHandler)



--event.listen(event: string, callback: function): boolean
-- if "interrupted" then write to disk and exit
-- key_up(keyboardAddress: string, char: number, code: number, playerName: string)
-- clipboard(keyboardAddress: string, value: string, playerName: string)
-- modem_message(receiverAddress: string, senderAddress: string, port: number, distance: number, ...)
--event.pull([timeout: number], [name: string], ...): string, ...
--event.pullFiltered([timeout: number], [filter: function]): string, ...

--term.isAvailable(): boolean
--term.setCursor(col: number, row: number)
--term.getCursor(): number, number
--term.clear()
--term.clearLine()
--term.setCursorBlink(enabled: boolean)
--term.write(value: string[, wrap: boolean])

--serialization.serialize(value: any except functions[, pretty:boolean/number]): string
--serialization.unserialize(value: string): any

--component.isAvailable(componentType: string): boolean

--internet.request(url: string[, data: string or table[, headers: table[, method: string]]]): function

--keyboard.isKeyDown(charOrCode: any): boolean

--filesystem.exists(path: string)

--maxPacketSize(): number
--open(port: number): boolean
--send(address: string, port: number[, ...]): boolean
--close([port: number]): boolean
--broadcast(port: number, ...): boolean
--setStrength(value: number): number

--io.open(name,"wr")
--f:write(meesage)
--f:close()
--f:read("*a")

--wireless tier 2 max x and y diff is 260