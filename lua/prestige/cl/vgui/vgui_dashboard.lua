local PANEL = {}

local sw = function(v) return (v / 1920) * ScrW() end
local sh = function(v) return (v / 1080) * ScrH() end

local navbarSize = sh(50)

function PANEL:Init()
    // 1 - home
    // 2 - scoreboard
    // 3 - shop
    self.currentPanel = 1
    self:SetDraggable(false)

    wimg.Register('delete', "https://i.imgur.com/OunTuKU.png")
    self.closeButtonMat = wimg.Create('delete')

    self.mytitle = vgui.Create("DLabel", self)
    self.mytitle:SetText("Prestige")
    self.mytitle:SetFont("HZNPrestige:B:30")
    self.mytitle:SetColor(Color(255, 255, 255))
    self.mytitle:SetContentAlignment(5)
    
    local boxSize = 1.5
    local border = 2
    local leftPadding = 5
    self.myPoints = vgui.Create("DPanel", self)
    self.myPoints.Paint = function(s, w, h)
        surface.SetFont("HZNPrestige:B:30")
        local formatedCash = LocalPlayer():HZN_GetPrestige() .. "p"
        local tw, th = surface.GetTextSize(formatedCash)

        draw.RoundedBox(4, sw(leftPadding), h/2 - (sh(20) * boxSize)/2, (tw) * boxSize, sh(20 * boxSize), HZNPrestige.Colors["LowerPanel"])
        draw.RoundedBox(4, sw(leftPadding + border), h/2 - (sh(20) * boxSize)/2 + (border), (tw) * boxSize - (border * 2), sh(20 * boxSize) - (border * 2), HZNPrestige.Colors["DashboardHeader"])
        draw.SimpleText(formatedCash, "HZNPrestige:B:25", leftPadding + ((tw) * boxSize) / 2, h/2, HZNPrestige.Colors["TextColor"], 1, 1)
    end

    self:SetTitle(" ")
    self:ShowCloseButton(false)

    self.closeBtn = vgui.Create("DButton", self)
    self.closeBtn:SetSize(sw(25), sh(25))
    self.closeBtn:SetText("")
    function self.closeBtn:Paint(w,h)
        //draw.RoundedBox(16, 0, 0, w, h, HZNPrestige.Colors["CloseButton"])

        local col = color_white
        if self:IsHovered() then
            col = Color(col.r, col.g, col.b, 125)
        end

        self:GetParent().closeButtonMat(0, 0, w, h, col)
    end
    function self.closeBtn:DoClick()
        self:GetParent():Remove()
    end

    net.Start("HZNPrestige:GetPlayerItems")
    net.SendToServer()
end

function PANEL:SetMyTitle(title)
    self.mytitle:SetText(title)
end

function PANEL:PerformLayout()

end

function PANEL:SetPageID(id)
    self.currentPanel = id
end

function PANEL:Setup(page)
    self:SetSize(sw(450), sh(320))
    self:Center()

    if (page) then
        self:SetPageID(page)
    end

    self.myPoints:SetSize(sw(self:GetWide() / 2 - 60), sh(navbarSize))
    self.myPoints:SetPos(sw(5), 0)

    self.closeBtn:SetPos(self:GetWide() - sw(36), navbarSize/2 - self.closeBtn:GetTall()/2 + sh(1))
    
    if (self.navbar) then
        self.navbar:Remove()
    end

    self.mytitle:SetSize(self:GetWide(), self:GetTall())
    self.mytitle:SetPos(0, navbarSize/2 - self.mytitle:GetTall()/2)
    self.mytitle:SetContentAlignment(5)

    self.navbar = vgui.Create("HZNPrestige:Navbar", self)
    self.navbar:SetSize(self:GetWide(), navbarSize)
    self.navbar:SetPos(0, sh(50))
    self.navbar:SetMyID(self.currentPanel)
    self.navbar:SetMyCallback(function(id)
        self:SetNewPanel(id)
    end)

    self.navbar:Setup()

    self:SetMyTitle("Prestige")

    self:MakePopup()

    if (self.currentPanel == 1) then
        self:SetupHome()
    elseif (self.currentPanel == 2) then
        self:SetupScoreboard()
    elseif (self.currentPanel == 3) then
        self:SetupShop()
    end

    if (!self.pnl) then return end

    self.pnl:SetSize(self:GetWide() - sw(20), self:GetTall() - (navbarSize + sh(70)))
    self.pnl:SetPos(sw(10), navbarSize + sh(60))
    self.pnl:Setup()
end

function PANEL:SetupHome()
    if (self.pnl) then
        self.pnl:Remove()
    end

    self.pnl = vgui.Create("HZNPrestige:Home", self)
end

function PANEL:SetupScoreboard()
    if (self.pnl) then
        self.pnl:Remove()
    end

    self:SetSize(sw(450), sh(450))
    self:Center()
    self.navbar:SetSize(self:GetWide(), navbarSize)
    self.navbar:Setup()
    self.closeBtn:SetPos(self:GetWide() - sw(36), navbarSize/2 - self.closeBtn:GetTall()/2 + sh(1))
    self.mytitle:SetSize(self:GetWide(), self:GetTall())
    self.mytitle:SetPos(0, navbarSize/2 - self.mytitle:GetTall()/2)

    self.pnl = vgui.Create("HZNPrestige:Scoreboard", self)
end

function PANEL:SetupShop()
    if (self.pnl) then
        self.pnl:Remove()
    end

    self:SetSize(sw(800), sh(600))
    self:Center()
    self.navbar:SetSize(self:GetWide(), navbarSize)
    self.navbar:Setup()
    self.closeBtn:SetPos(self:GetWide() - sw(36), navbarSize/2 - self.closeBtn:GetTall()/2 + sh(1))
    self.mytitle:SetSize(self:GetWide(), self:GetTall())
    self.mytitle:SetPos(0, navbarSize/2 - self.mytitle:GetTall()/2)

    self.pnl = vgui.Create("HZNPrestige:Shop", self)
end

function PANEL:SetNewPanel(id)
    self.currentPanel = id
    self:Setup()
end

function PANEL:Paint(w, h)
    //HZNShadows.BeginShadow( "HZNPrestige:Menu2" )
    local x, y = 0, 0
    draw.RoundedBox(4, x, y, w, h, HZNPrestige.Colors["LowerPanel"])
    draw.RoundedBoxEx(4, x, y, w, sh(50), HZNPrestige.Colors["DashboardHeader"], true, true, false, false)
    //HZNShadows.EndShadow( "HZNPrestige:Menu2", x, y, 1, 1, 1, 255, 0, 0, false )
end

vgui.Register("HZNPrestige:Dashboard", PANEL, "DFrame")