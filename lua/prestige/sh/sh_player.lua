local meta = FindMetaTable("Player")

function meta:HZN_GetPrestige()
    return math.Round(self:GetNWFloat("HZN_Prestige", 0), 3)
end