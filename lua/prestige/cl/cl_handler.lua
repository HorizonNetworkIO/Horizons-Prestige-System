local readTable = net.ReadTable
local netStart = net.Start
local netSend = net.SendToServer
local readUInt = net.ReadUInt

HZNPrestige.Scoreboard = {}

local open_menu = function()
    if (HZNPrestige.menu) then
        HZNPrestige.menu:Remove()
    end

    HZNPrestige.menu = vgui.Create("HZNPrestige:Dashboard")
    HZNPrestige.menu:Setup()

    netStart("HZNPrestige:GetScoreboard")
    netSend()
end

local open_shop = function()
    if (HZNPrestige.menu) then
        HZNPrestige.menu:Remove()
    end

    HZNPrestige.menu = vgui.Create("HZNPrestige:Dashboard")
    HZNPrestige.menu:Setup(3)

    netStart("HZNPrestige:GetScoreboard")
    netSend()
end


local receive_scoreboard = function()
    HZNPrestige.Scoreboard = readTable()
end

local receive_items = function()
    HZNPrestige.Items = readTable()
end

local sync_items = function()
    HZNPrestige.ShopItems = readTable()
end

concommand.Add("hzn_prestige_menu", open_menu)
concommand.Add("hzn_prestige_shop", open_shop)
net.Receive("HZNPrestige:SyncScoreboard", receive_scoreboard)
net.Receive("HZNPrestige:SyncPlayerItems", receive_items)
net.Receive("HZNPrestige:SyncItems", sync_items)