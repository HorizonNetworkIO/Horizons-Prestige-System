local PANEL = {}

local sw = function(v) return ((ScrW() * v)/1920) end
local sh = function(v) return ((ScrH() * v)/1080) end

local get_item_position = function(panel, index)
    local x = ((index-1) % panel.maxCols) * (panel.itemWide + panel.itemSpacing)
    local y = math.floor((index-1) / panel.maxCols) * (panel.itemTall + panel.itemSpacing)
    
    return x, y
end



function PANEL:Init()
    self.items = {}
    self.itemWide = sw(150)
    self.itemTall = sh(150)
    self.itemSpacing = sw(5)
    self.maxCols = 6

    self.VBar:Remove()
    self.VBar = vgui.Create("DVScrollBar", self)
    self.VBar:Dock(6)
    self.VBar:SetSize(0, 0)
end

function PANEL:SetUp()
    self.itemWide = self:GetWide() / self.maxCols - (self.itemSpacing/self.maxCols)
    -- self.itemTall = self:GetWide() / self.maxCols - (self.itemSpacing/self.maxCols)


end

function PANEL:SetItemWide(w)
    self.itemWide = w
end

function PANEL:SetItemTall(t)
    self.itemTall = t
end

function PANEL:SetCols(max)
    self.maxCols = max
end

function PANEL:SetSpacing(val)
    self.itemSpacing = val
end

function PANEL:AddItems(item)
    table.insert(self.items, item)
    
    item:SetParent(self)
    item:SetSize(self.itemWide, self.itemTall)
    local posX, posY = get_item_position(self, #self.items)
    item:SetPos(posX, posY)
end

vgui.Register("HZNPrestige:Grid", PANEL, "DScrollPanel")