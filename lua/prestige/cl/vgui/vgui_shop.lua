local PANEL = {}

local sw = function(v) return ((ScrW() * v)/1920) end
local sh = function(v) return ((ScrH() * v)/1080) end

function PANEL:Init()
    self:Setup()
end

function PANEL:Setup()
    if (self.grid) then
        self.grid:Remove()
    end

    self.grid = vgui.Create("HZNPrestige:Grid", self)
    self.grid:SetSize(self:GetWide() - sw(10), self:GetTall() - sh(10))
    self.grid:SetPos(sw(5),sh(5))
    self.grid:SetCols(3)
    self.grid:SetUp()


    if (!HZNPrestige.ShopItems) then
        print("[HZNPrestige] No shop items found!")
        timer.Simple(1, function()
            if (IsValid(self)) then
                self:Setup()
            end
        end)
        return
    end

    for k,v in ipairs(HZNPrestige.ShopItems) do
        local pnl = vgui.Create("HZNPrestige:ShopPanel")
        self.grid:AddItems(pnl)
        pnl:SetItem(k)
    end
end

function PANEL:PerformLayout()
end

function PANEL:Paint(w,h)

end

vgui.Register("HZNPrestige:Shop", PANEL, "DPanel")