local PANEL = {}

local sw = function(v) return ((ScrW() * v)/1920) end
local sh = function(v) return ((ScrH() * v)/1080) end

function PANEL:Init()
    self.item = nil

    wimg.Register("mp5", "https://i.imgur.com/VE5gcwj.png")
    self.gunMat = wimg.Create("mp5")

    wimg.Register("shield", "https://i.imgur.com/tEdqCPH.png")
    self.shieldMat = wimg.Create("shield")

    wimg.Register("heart", "https://i.imgur.com/INAYRkF.png")
    self.heartMat = wimg.Create("heart")

    wimg.Register("pistol", "https://i.imgur.com/Aqzb6vH.png")
    self.pistolMat = wimg.Create("pistol")

    wimg.Register("boots", "https://i.imgur.com/Qr0EJMV.png")
    self.bootsMat = wimg.Create("boots")

    wimg.Register("key", "https://i.imgur.com/ZqFaaqT.png")
    self.keyMat = wimg.Create("key")
end

function PANEL:SetUp()
    self.itemamount = 0
    for k,v in ipairs(HZNPrestige.Items) do
        if self.item.id == v then
            self.itemamount = self.itemamount + 1
        end
    end

    self.purchased = false
    self.amountleft = self.item.amount - self.itemamount

    if (self.item.amount != 0) then
        if (self.itemamount >= self.item.amount) then
            self.purchased = true
        end
    end

    self.hasEnough = LocalPlayer():HZN_GetPrestige() >= self.item.price

    self.purchaseBtn = vgui.Create("DButton", self)
    self.purchaseBtn:SetText("")
    self.purchaseBtn:SetSize(self:GetWide(), sh(40))
    self.purchaseBtn:SetPos(0, self:GetTall() - sh(40))
    self.purchaseBtn.Paint = function(s, w, h)
        if (s:IsHovered()) then
            col = HZNPrestige.Colors["HoverButton"]
        else
            col = HZNPrestige.Colors["Button"]
        end

        local text = self.purchased and "Purchased" or self.hasEnough and (self.item.amount == 0 and "Purchase" or "Purchase - " .. self.amountleft .. " left") or "Not Enough"

        draw.RoundedBox(2, 0, 0, w, h, col)
        HZNPrestige:DrawText(text, "HZNPrestige:B:25", w/2, h/2, self.purchased and HZNPrestige.Colors["PriceText"] or HZNPrestige.Colors["TextColor"], 1, 1, 1.1, 200)
    end
    self.purchaseBtn.DoClick = function(s)
        if (!self.purchased) then
            if self.hasEnough then
                self.confirmBtn = vgui.Create("HZNPresitge:Confirm", self)
                self.confirmBtn:SetUp("Are you sure you want to purchase this item for " .. self.item.price .. "p?\n" .. self.item.description)
                self.confirmBtn:SetApproveCallback(function()
                    net.Start("HZNPrestige:TryBuy")
                        net.WriteString(tostring(self.item.id))
                    net.SendToServer()
                    timer.Simple(.5, function()
                        self.itemamount = 0
                        for k,v in ipairs(HZNPrestige.Items) do
                            if self.item.id == v then
                                self.itemamount = self.itemamount + 1
                            end
                        end
                    
                        self.purchased = false
                        self.amountleft = self.item.amount - self.itemamount
                    
                        if (self.item.amount != 0) then
                            if (self.itemamount >= self.item.amount) then
                                self.purchased = true
                            end
                        end
                    
                        self.hasEnough = LocalPlayer():HZN_GetPrestige() >= self.item.price
                    end)
                end)
            else
                chat.AddText(HZNPrestige.Colors["DashboardHeader"], "[Prestige] ", color_white, "You do not have enough prestige to purchase this item.")
            end
        end
    end

    // text box for description
    self.desc = vgui.Create("DLabel", self)
    self.desc:SetText(self.item.description)
    self.desc:SetSize(self:GetWide() - sw(10), self:GetTall() - sh(50) - sh(40))
    self.desc:SetPos(sw(10), sh(50))
    self.desc:SetWrap(true)
    self.desc:SetAutoStretchVertical(true)
    self.desc:SetFont("HZNPrestige:N:15")
    self.desc:SetTextColor(color_white)
    self.desc:SetContentAlignment(5)
    self.desc:SetTextInset(sw(5), sh(5))
end

function PANEL:Paint(w,h)
    draw.RoundedBox(0, 0, 0, w, h, HZNPrestige.Colors["BackBox"])
    HZNPrestige:DrawText(self.item.name, "HZNPrestige:B:20", sw(55), sh(25), HZNPrestige.Colors["TextColor"], 0, 1, 1.3, 200)
    HZNPrestige:DrawText(self.item.price .. "p", "HZNPrestige:B:25", w - sw(15), sh(25), HZNPrestige.Colors["PriceText"], 2, 1, 1.3, 200)

    if (self.item) then
        if (self.item.icon == 1) then
            self.gunMat(sw(10), sh(12), sw(30), sh(30), HZNPrestige.Colors["LowerPanel"])
        elseif (self.item.icon == 2) then
            self.shieldMat(sw(10), sh(12), sw(30), sh(30), HZNPrestige.Colors["LowerPanel"])
        elseif (self.item.icon == 3) then
            self.heartMat(sw(10), sh(12), sw(30), sh(30), HZNPrestige.Colors["LowerPanel"])
        elseif (self.item.icon == 4) then
            self.pistolMat(sw(10), sh(12), sw(30), sh(30), HZNPrestige.Colors["LowerPanel"])
        elseif (self.item.icon == 5) then
            self.bootsMat(sw(10), sh(12), sw(30), sh(30), HZNPrestige.Colors["LowerPanel"])
        elseif (self.item.icon == 6) then
            self.keyMat(sw(10), sh(12), sw(30), sh(30), HZNPrestige.Colors["LowerPanel"])
        end
    end
end

function PANEL:SetItem(index)
    self.item = HZNPrestige.ShopItems[index]
    self:SetUp()
end

vgui.Register("HZNPrestige:ShopPanel", PANEL, "DPanel")