local component     = require("component")
local event         = require("event")
local term          = require("term")
local serialization = require("serialization")
local internet      = require("internet")
local keyboard      = require("keyboard")
local filesystem    = require("filesystem")
local m = component.modem
local g = component.gpu
local width, height = g.maxResolution()

local robots = {}

function modemMessage(_, receiverAddress, senderAddress, port, distance, from, command, serialData)
    if command == 'addRobot' then
        robots[from] = {name='test'}
    end
end
event.listen("modem_message", modemMessage)

function keyUp(_, keyboardAddress, char, code, playerName)

end

m.open(244)
m.setStrength(16)
function main()
    for row=1,height-1 do
        for column=1,width do
            g.set(column,line," ")
        end
    end
    g.set(1,1,'Robots: ')
    local row = 2
    for k,v in pairs(robots) do
        g.set(1,row,' --' .. v.name)
        row = row + 1
    end
end
local timer = event.timer(.1, main, math.huge)

function interruptHandler()
    event.cancel(timer)
    term.clear()
end
event.listen("interrupted", interruptHandler)

while true do
    term.(1,height)
    term.read({nowrap=true})
    term.clearLine()
end

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

--tier 2
--max width  50
--max height 16

--wireless tier 2 max x and y diff is 260