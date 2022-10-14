local PANEL = {}

local sw = function(v) return ((ScrW() * v)/1920) end
local sh = function(v) return ((ScrH() * v)/1080) end

function PANEL:Init()
    wimg.Register("rightarrow", "https://i.imgur.com/kNpNd5D.png")
    self.rightArrowMat = wimg.Create("rightarrow")
end

function PANEL:Setup()
    if (self.tradeBtn) then
        self.tradeBtn:Remove()
    end
    if (self.midPnl) then
        self.midPnl:Remove()
    end
    if (self.confirmBtn) then
        self.confirmBtn:Remove()
    end

    self.midPnl = vgui.Create("DPanel", self)
    self.midPnl:SetSize(self:GetWide(), sh(130))
    self.midPnl:SetPos(0, 0)
    function self.midPnl:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, HZNPrestige.Colors["BackBox"])

        local formatedMoney = DLL.FormatMoney(LocalPlayer():getDarkRPVar("money"))
        local formatedConversionMoney = string.Comma(math.Round(LocalPlayer():getDarkRPVar("money") * HZNPrestige.Config.MoneyToPrestigeConversion, 3))

        HZNPrestige:DrawText("DarkRP Money", "HZNPrestige:N:25", w/2*.5, sh(45), HZNPrestige.Colors["TextColor"], 1, 1, 1.5, 0)
        HZNPrestige:DrawText(formatedMoney, "HZNPrestige:B:30", w/2*.5, h/2 + sh(15), HZNPrestige.Colors["TextColor"], 1, 1, 1.5, 50)

        self:GetParent().rightArrowMat(w/2-sw(25), h/2-sh(25), sw(50), sh(50))

        HZNPrestige:DrawText("Prestige Points", "HZNPrestige:N:25", w/2*1.5, sh(45), HZNPrestige.Colors["TextColor"], 1, 1, 0, 0)
        HZNPrestige:DrawText(formatedConversionMoney .. "p", "HZNPrestige:B:30", w/2*1.5, h/2 + sh(15), HZNPrestige.Colors["TextColor"], 1, 1, 0, 0)
    end
    
    self.tradeBtn = vgui.Create("DButton", self)
    self.tradeBtn:SetSize(self:GetWide() - sw(20), sh(60))
    self.tradeBtn:Dock(BOTTOM)
    self.tradeBtn:SetText(" ")
    self.tradeBtn:SetFont("HZNPrestige:B:25")
    self.tradeBtn:SetTextColor(HZNPrestige.Colors["TextColor"])

    function self.tradeBtn:DoClick()
        if (self.confirmBtn) then
            self.confirmBtn:Remove()
        end

        self.confirmBtn = vgui.Create("HZNPresitge:Confirm", self)
        self.confirmBtn:SetProtective(true)
        self.confirmBtn:SetUp("Are you sure you want to do that?\n Trading-In will completely reset your Money.\n There is absolutely no turning back after you confirm this action.")
        self.confirmBtn:SetApproveCallback(function()
            HZNPrestige:Log("Trading Money for Prestige Points...")
            HZNPrestige:TradeIn()
        end)
    end

    function self.tradeBtn:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, HZNPrestige.Colors["DashboardHeader"])

        if (self:IsHovered()) then
            draw.RoundedBox(0, 0, 0, w, h, HZNPrestige.Colors["Button"])
        end
        if (self:IsDown()) then
            draw.RoundedBox(0, 0, 0, w, h, HZNPrestige.Colors["ButtonDown"])
        end

        HZNPrestige:DrawText("TRADE IN", "HZNPrestige:B:25", w/2, h/2-sh(10), color_white, 1, 1)
        HZNPrestige:DrawText("(You may only TRADE IN once a week!)", "HZNPrestige:B:20", w/2, h/2+sh(12), HZNPrestige.Colors["TextColor"], 1, 1, 0, 0)
    end

end

function PANEL:Paint(w,h)
end

vgui.Register("HZNPrestige:Home", PANEL, "DPanel")