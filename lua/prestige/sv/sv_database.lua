HZNPrestige.Data = {}

local sqlInfo = {
    host = "",
    port = "",
    user = "",
    password = "",
    database = ""
}

function HZNPrestige.Data:InitializeDatabase()
    HZNPrestige.Data.db = mysqloo.connect(sqlInfo.host, sqlInfo.user, sqlInfo.password, sqlInfo.database, sqlInfo.port)
    HZNPrestige.Data.db:connect()

    HZNPrestige.Data.db.onConnected = function()
        HZNPrestige:Log("Connected to MySQL database.")
        HZNPrestige.Data:CreateTables()
    end

    HZNPrestige.Data.db.onConnectionFailed = function(db, err)
        HZNPrestige:Log("Connection to MySQL database failed! Error: " .. err)
    end
end

function HZNPrestige.Data:Query(query, callback)
    if (!HZNPrestige.Data.db) then 
        HZNPrestige:Log("Database not connected! Retrying connection...")
        
        HZNPrestige.Data:InitializeDatabase()
    end
    
    local q = HZNPrestige.Data.db:query(query)
    q.onSuccess = function(q, data)
        callback(data)
    end
    q.onError = function(q, err)
        HZNPrestige:Log("MySQL Error: "..err)
    end
    q:start()
end

function HZNPrestige.Data:CreateTables()
    HZNPrestige.Data:Query([[
        CREATE TABLE IF NOT EXISTS
            `hzn_prestige_players` (
            `steamid` VARCHAR(255) NOT NULL,
            `points` DOUBLE(8, 3) NOT NULL,
            `lastprestiged` VARCHAR(255) NOT NULL,
        PRIMARY KEY (`steamid`))
            ]], function()
        HZNPrestige:Log("Created Players Table.")
    end)

    HZNPrestige.Data:Query([[
        CREATE TABLE IF NOT EXISTS
            `hzn_prestige_items` (
            `steamid` VARCHAR(255) NOT NULL,
            `item` INT NOT NULL)
            ]], function()
        HZNPrestige:Log("Created Items Table.")
    end)

    HZNPrestige.Data:FetchScoreboard()
end

function HZNPrestige.Data:LoadPlayer(ply)
    local q = "SELECT points FROM `hzn_prestige_players` WHERE `steamid` = '" .. ply:SteamID() .. "'"
    HZNPrestige.Data:Query(q, function(data)
        if (data and data[1]) then
            HZNPrestige:Log("Loaded " .. ply:Nick() .. "'s data.")
            ply:SetNWInt("HZN_Prestige", data[1].points)
        end
    end)
end

function HZNPrestige.Data:FetchScoreboard()
    // get top 10 players with most points
    HZNPrestige:Log("Fetching scoreboard...")
    local q = "SELECT * FROM `hzn_prestige_players` ORDER BY `points` DESC LIMIT 10"
    HZNPrestige.Data:Query(q, function(data)
        if (data) then
            HZNPrestige.Data.Scoreboard = data
        end
    end)
end

function HZNPrestige.Data:IsPlayerInData(ply, callback)
    local q = "SELECT steamid FROM `hzn_prestige_players` WHERE `steamid` = '" .. ply:SteamID() .. "'"
    HZNPrestige.Data:Query(q, function(data)
        if (data and data[1]) then
            callback(true)
        else
            callback(false)
        end
    end)
end

function HZNPrestige.Data:CanTradeIn(ply, callback)
    local q = "SELECT lastprestiged FROM `hzn_prestige_players` WHERE `steamid` = '" .. ply:SteamID() .. "'"
    HZNPrestige.Data:Query(q, function(data)
        if (data and data[1]) then
            local lastPrestiged = data[1].lastprestiged
            local time = os.time()
            local diff = time - tonumber(lastPrestiged)
            if (diff > HZNPrestige.Config.Cooldown) then
                callback(true)
            else
                callback(false)
            end
        end
    end)
end

function HZNPrestige.Data:TradeIn(ply, point, money)
    local points = math.Round(point, 3)
    HZNPrestige.Data:IsPlayerInData(ply, function(inData)
        if (!inData) then
            local q = "INSERT INTO hzn_prestige_players (steamid, points, lastprestiged) VALUES ('"..ply:SteamID().."', "..points..", '" .. os.time() .. "') ON DUPLICATE KEY UPDATE points = GREATEST(0, points + "..points .. ")"
            HZNPrestige.Data:Query(q, function()
                HZNPrestige:Log(ply:Nick() .. " prestiged and gained " .. points .. " prestige points.")
                ply:SetNWFloat("HZN_Prestige", math.Clamp(ply:GetNWInt("HZN_Prestige") + points, 0, 1000000))
                ply:SetNWInt("HZNPrestige_LastTradeTime", os.time())

                HZNPrestige:Say(ply, "You traded in " .. DLL.FormatMoney(money) .. " for " .. points .. " prestige points!")
                HZNPrestige:Say(nil, ply:Nick() .. " just traded in " .. DLL.FormatMoney(money) .. " for " .. points .. " prestige points!", ply)

                // reset
                ply:addMoney(-ply:getDarkRPVar("money"))

                hook.Run("HZNPrestige:TradedIn", ply, points, money)

                HZNPrestige.Data:FetchScoreboard()
            end)
        else
            local q = "SELECT lastprestiged FROM hzn_prestige_players WHERE steamid = '" .. ply:SteamID() .. "'"
            HZNPrestige.Data:Query(q, function(data)
                local lastTime = data[1].lastprestiged
                local timeDiff = os.time() - lastTime
                if (timeDiff < HZNPrestige.Config.Cooldown) then
                    HZNPrestige:Log(ply:Nick() .. " tried to prestige but is on cooldown.")
                    HZNPrestige:Say(ply, "You can't trade in for points right now. Try again in " .. sam.reverse_parse_length((HZNPrestige.Config.Cooldown - timeDiff)/60) .. ".")
                else
                    local q = "UPDATE hzn_prestige_players SET points = GREATEST(0, points + "..points .. "), lastprestiged = '" .. os.time() .. "' WHERE steamid = '" .. ply:SteamID() .. "'"
                    HZNPrestige.Data:Query(q, function()
                        HZNPrestige:Log(ply:Nick() .. " prestiged and gained " .. points .. " prestige points.")
                        local beforePoints = ply:GetNWFloat("HZN_Prestige")
    
                        ply:SetNWFloat("HZN_Prestige", math.Round(beforePoints + points, 3))
                        ply:SetNWInt("HZNPrestige_LastTradeTime", os.time())

                        HZNPrestige:Say(ply, "You traded in " .. DLL.FormatMoney(money) .. " for " .. points .. " prestige points!")
                        HZNPrestige:Say(nil, ply:Nick() .. " just traded in " .. DLL.FormatMoney(money) .. " for " .. points .. " prestige points!", ply)

                        // reset
                        ply:addMoney(-ply:getDarkRPVar("money"))

                        hook.Run("HZNPrestige:TradedIn", ply, points, money)

                        HZNPrestige.Data:FetchScoreboard()
                    end)
                end
            end)
        end
    end)
end

function HZNPrestige:GetItems(ply, callback)
    local q = "SELECT item FROM `hzn_prestige_items` WHERE `steamid` = '" .. ply:SteamID() .. "'"
    HZNPrestige.Data:Query(q, function(data)
        if (data and data[1]) then
            local items = {}
            for k, v in pairs(data) do
                table.insert(items, v.item)
            end

            callback(items)
        else
            callback({})
        end
    end)
end

function HZNPrestige:PurchaseItem(ply, itemID)
    local q = "INSERT INTO hzn_prestige_items (steamid, item) VALUES ('"..ply:SteamID().."', "..itemID..")"
    HZNPrestige.Data:Query(q, function()
        HZNPrestige:Log(ply:Nick() .. " purchased item " .. itemID .. ".")
        HZNPrestige:SyncPlayerItems(ply)
    end)
end

function HZNPrestige:TakePrestige(ply, amount)
    local q = "SELECT lastprestiged FROM hzn_prestige_players WHERE steamid = '" .. ply:SteamID() .. "'"
    HZNPrestige.Data:Query(q, function(data)
        local lastPrestiged
        if (data and data[1]) then
            lastPrestiged = data[1].lastprestiged
        else
            lastPrestiged = 0
        end

        local q = "INSERT INTO hzn_prestige_players (steamid, points, lastprestiged) VALUES ('"..ply:SteamID().."', "..amount..", "..lastPrestiged..") ON DUPLICATE KEY UPDATE points = GREATEST(0, points - ".. amount .. ")"
        HZNPrestige.Data:Query(q, function()
            ply:SetNWFloat("HZN_Prestige", math.Clamp(ply:GetNWInt("HZN_Prestige") - amount, 0, 1000000))
            HZNPrestige.Data:FetchScoreboard()
        end)

    end)
end