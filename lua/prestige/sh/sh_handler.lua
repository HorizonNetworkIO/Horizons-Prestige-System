function HZNPrestige:GetMoneyConversion(money)
    return HZNPrestige.Config.MoneyToPrestigeConversion * money
end

function HZNPrestige:TradeIn()
    net.Start("HZNPrestige:TradeIn")
    net.SendToServer()
end

if (SERVER) then
    util.AddNetworkString("HZNPrestige:Say")
    function HZNPrestige:Say(ply, msg, ignorePly)
        net.Start("HZNPrestige:Say")
        net.WriteString(msg)
        if (ply) then
            net.Send(ply)
        else
            for k,v in ipairs(player.GetAll()) do
                if (v ~= ignorePly) then
                    net.Send(v)
                end
            end
        end
    end
else
    net.Receive("HZNPrestige:Say", function()
        local msg = net.ReadString()
        chat.AddText(Color(197, 61, 209), "[Prestige] ", color_white, msg)
    end)
end