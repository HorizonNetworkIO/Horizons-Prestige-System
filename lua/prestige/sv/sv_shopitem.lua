HZNPrestige.ShopItems = {}

function HZNPrestige:AddItem(tbl)
    tbl.id = #HZNPrestige.ShopItems + 1
    table.insert(HZNPrestige.ShopItems, tbl)
end

util.AddNetworkString("HZNPrestige:SyncItems")
function HZNPrestige:SyncItems(ply)
    local items = {}

    for k,v in ipairs(HZNPrestige.ShopItems) do
        table.insert(items, {
            name = v.name,
            price = v.price,
            id = v.id,
            description = v.description,
            icon = v.icon,
            amount = v.amount
        })
    end

    net.Start("HZNPrestige:SyncItems")
    net.WriteTable(items)
    if (ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

util.AddNetworkString("HZNPrestige:TryBuy")
net.Receive("HZNPrestige:TryBuy", function(len, ply)
    local id = net.ReadString()
    id = tonumber(id)

    HZNPrestige:TryBuyItem(ply, id)
end)

function HZNPrestige:TryBuyItem(ply, id)
    local item = HZNPrestige.ShopItems[id]
    if (!item) then 
        HZNPrestige:Log("Item not found! Failed to buy item. (ID: " .. id .. ")")
        return 
    end

    if (item.price > ply:HZN_GetPrestige()) then
        HZNPrestige:Say(ply, "Not enough to purchase!")
        return
    end

    item.canBuy(ply, function(can)
        if (!can) then
            HZNPrestige:Say(ply, "You already have this item!")
            return
        end

        HZNPrestige:GetItems(ply, function(items)
            local amount = 0
            for k,v in ipairs(items) do
                if (v == id) then
                    amount = amount + 1
                end
            end

            HZNPrestige:Log("You have " .. amount .. " of " .. item.name .. "! (" .. item.amount .. ")")

            if (item.amount ~= 0 and amount >= item.amount) then
                HZNPrestige:Say(ply, "You already have the max amount of this item!")
                return
            end

            HZNPrestige:TakePrestige(ply, item.price)
            item.buy(ply)
            HZNPrestige:PurchaseItem(ply, id)
        end)
    end)
end

function HZNPrestige:LoadItems()
    HZNPrestige:AddItem({
        name = "+5 Armor",
        description = "A permanent upgrade that buffs your armor by 5. This can be accessed with the buffs npc.",
        price = 2,
        canBuy = function(ply, callback)
            callback(true)
        end,
        buy = function(ply)
            HZNBuffs:AddBuff(ply:SteamID(), 2)
        end,
        icon = 2,
        amount = 3, // 0 = unlimited, amount of times this can be purchased per player
    })

    HZNPrestige:AddItem({
        name = "+5 HP",
        description = "A permanent upgrade that buffs your HP by 5. This can be accessed with the buffs npc.",
        price = 2,
        canBuy = function(ply, callback)
            callback(true)
        end,
        buy = function(ply)
            HZNBuffs:AddBuff(ply:SteamID(), 1)
        end,
        icon = 3,
        amount = 3, // 0 = unlimited, amount of times this can be purchased per player
    })

    HZNPrestige:AddItem({
        name = "Colt 1911",
        description = "Includes a permanent Colt 1911. This can be accessed with the !perma menu.",
        price = 2.75,
        canBuy = function(ply, callback)
            HZNPerma:HasPerma(ply:SteamID(), "m9k_colt1911", function(has)
                if (has) then
                    callback(false)
                else
                    callback(true)
                end
            end)
        end,
        buy = function(ply)
            HZNPerma:AddPermaToPly(ply:SteamID(), "m9k_colt1911")
        end,
        icon = 4,
        amount = 1, // 0 = unlimited, amount of times this can be purchased per player
    })

    HZNPrestige:AddItem({
        name = "Glock 18",
        description = "Includes a permanent Glock 18. This can be accessed with the !perma menu.",
        price = 2.75,
        canBuy = function(ply, callback)
            HZNPerma:HasPerma(ply:SteamID(), "m9k_glock", function(has)
                if (has) then
                    callback(false)
                else
                    callback(true)
                end
            end)
        end,
        buy = function(ply)
            HZNPerma:AddPermaToPly(ply:SteamID(), "m9k_glock")
        end,
        icon = 4,
        amount = 1, // 0 = unlimited, amount of times this can be purchased per player
    })

    HZNPrestige:AddItem({
        name = "STEN",
        description = "Includes a permanent STEN. This can be accessed with the !perma menu.",
        price = 4,
        canBuy = function(ply, callback)
            HZNPerma:HasPerma(ply:SteamID(), "m9k_sten", function(has)
                if (has) then
                    callback(false)
                else
                    callback(true)
                end
            end)
        end,
        buy = function(ply)
            HZNPerma:AddPermaToPly(ply:SteamID(), "m9k_sten")
        end,
        icon = 1,
        amount = 1, // 0 = unlimited, amount of times this can be purchased per player
    })

    HZNPrestige:AddItem({
        name = "+5% Walk Speed",
        description = "A permanent upgrade that buffs your walk speed by 5%. This can be accessed with the buffs npc.",
        price = 3,
        canBuy = function(ply, callback)
            callback(true)
        end,
        buy = function(ply)
            HZNBuffs:AddBuff(ply:SteamID(), 3)
        end,
        icon = 5,
        amount = 5, // 0 = unlimited, amount of times this can be purchased per player
    })

    HZNPrestige:AddItem({
        name = "+5% Run Speed",
        description = "A permanent upgrade that buffs your run speed by 5%. This can be accessed with the buffs npc.",
        price = 4,
        canBuy = function(ply, callback)
            callback(true)
        end,
        buy = function(ply)
            HZNBuffs:AddBuff(ply:SteamID(), 4)
        end,
        icon = 5,
        amount = 5, // 0 = unlimited, amount of times this can be purchased per player
    })

    HZNPrestige:AddItem({
        name = "+5% Jump Height",
        description = "A permanent upgrade that buffs your jump height by 5%. This can be accessed with the buffs npc.",
        price = 4,
        canBuy = function(ply, callback)
            callback(true)
        end,
        buy = function(ply)
            HZNBuffs:AddBuff(ply:SteamID(), 5)
        end,
        icon = 5,
        amount = 5, // 0 = unlimited, amount of times this can be purchased per player
    })

    HZNPrestige:AddItem({
        name = "+5% Lockpick Speed",
        description = "A permanent upgrade that increases your lockpick speed by 5%. This can be accessed with the buffs npc.",
        price = 4,
        canBuy = function(ply, callback)
            callback(true)
        end,
        buy = function(ply)
            HZNBuffs:AddBuff(ply:SteamID(), 6)
        end,
        icon = 6,
        amount = 5, // 0 = unlimited, amount of times this can be purchased per player
    })

    HZNPrestige:SyncItems()
end