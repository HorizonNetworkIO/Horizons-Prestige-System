util.AddNetworkString("HZNPrestige:TradeIn")
util.AddNetworkString("HZNPrestige:GetScoreboard") // Received from client
util.AddNetworkString("HZNPrestige:SyncScoreboard") // Sent to client
util.AddNetworkString("HZNPrestige:GetPlayerItems") // Received from client
util.AddNetworkString("HZNPrestige:SyncPlayerItems") // Sent to client

net.Receive("HZNPrestige:TradeIn", function(len, ply)
    local points = tonumber(HZNPrestige:GetMoneyConversion(ply:getDarkRPVar("money")))

    HZNPrestige.Data:TradeIn(ply, points, ply:getDarkRPVar("money"))
end)

net.Receive("HZNPrestige:GetScoreboard", function(len, ply)
    HZNPrestige:SyncScoreboard(ply)
end)

net.Receive("HZNPrestige:GetPlayerItems", function(len, ply)
    HZNPrestige:SyncPlayerItems(ply)
end)

function HZNPrestige:SyncScoreboard(ply)
    if (!HZNPrestige.Data or !HZNPrestige.Data.Scoreboard) then return end
    net.Start("HZNPrestige:SyncScoreboard")
        net.WriteTable(HZNPrestige.Data.Scoreboard)
    net.Broadcast()
end

function HZNPrestige:SyncPlayerItems(ply)
    HZNPrestige:GetItems(ply, function(items)
        net.Start("HZNPrestige:SyncPlayerItems")
            net.WriteTable(items)
        net.Send(ply)
    end)
end