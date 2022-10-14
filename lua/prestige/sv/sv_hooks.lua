hook.Add("HZNLib:FullSpawn", "HZNPrestige:PlayerInitialSpawn", function(ply)
    // load player's data
    HZNPrestige.Data:LoadPlayer(ply)
    // sync scoreboard
    HZNPrestige:SyncScoreboard(ply)
    // sync shop items
    HZNPrestige:SyncItems(ply)
end)

hook.Add("PlayerSay", "HZNPrestige:PlayerChat", function(ply, text)
    if (string.lower(text) == "!prestige") then
        ply:ConCommand("hzn_prestige_menu")
        return ""
    end

    if (string.lower(text) == "!shop") then
        ply:ConCommand("hzn_prestige_shop")
        return ""
    end
end)