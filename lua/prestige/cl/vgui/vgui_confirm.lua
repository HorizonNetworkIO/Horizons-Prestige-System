local PANEL = {}

local sw = function(v) return (v / 1920) * ScrW() end
local sh = function(v) return (v / 1080) * ScrH() end

local get_wide
local get_tall

function PANEL:Init()
    self:SetTitle("")
    self:ShowCloseButton(false)
    self.readyToGo = false

    self.protectedButton = false

    self.assureText = ""
end

function PANEL:SetProtective(bool)
    self.protectedButton = bool
    self.readyToGo = true
end

function PANEL:SetUp(assureText)
    self.assureText = assureText

    get_wide = function() surface.SetFont("HZNPrestige:B:20") return select(1, surface.GetTextSize(assureText)) end
    get_tall = function() surface.SetFont("HZNPrestige:B:20") return select(2, surface.GetTextSize(assureText)) end

    self:SetSize(get_wide() + sw(50), get_tall() + sh(90))
    self:SetPos(ScrW()/2 - (self:GetWide()/2), ScrH()/2 - (self:GetTall()/2))

    self.denyBtn = vgui.Create("DButton", self)
    self.denyBtn:SetText("Cancel")
    self.denyBtn:SetFont("HZNPrestige:B:25")
    self.denyBtn:SetTextColor(Color(255, 255, 255))
    self.denyBtn.DoClick = function()
        self:Remove()
    end

    self.approveBtn = vgui.Create("DButton", self)
    self.approveBtn:SetText("Confirm")
    self.approveBtn:SetFont("HZNPrestige:B:25")
    self.approveBtn:SetTextColor(Color(255, 255, 255))
  
    function self.denyBtn:Paint(w, h)
        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 200))

        if self:IsHovered() then
            draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 150))
        end
    end

    local w, h = self:GetSize()
    h = h/2

    function self.approveBtn:Paint(w, h)
        -- must be hovered for 3 seconds before it fills up

        local width
        if (self:GetParent().protectedButton) then
            if self:IsHovered() then
                self.hoveredTime = self.hoveredTime + (SysTime() - self.starTime)/1000
            else
                self.hoveredTime = 0
                self.starTime = SysTime()
            end
    
            width = Lerp(self.hoveredTime, 0, get_wide())
        else
            width = get_wide()
        end
       

        if (width >= get_wide()) then
            self:GetParent().readyToGo = true
        else
            self:GetParent().readyToGo = false
        end

        draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 100))

        if self:IsHovered() then
            draw.RoundedBox(2, 0, 0, width, h, Color(0, 0, 0, math.Clamp(width * 2, 100, 200)))
        end
    end

    self.denyBtn:SetSize(w/2 - sw(60), h-sh(30))
    self.denyBtn:SetPos(sw(20), h+sh(20))

    self.approveBtn:SetSize(w/2 - sw(60), h-sh(30))
    self.approveBtn:SetPos(w/2+sw(20), h+sh(20))

    self:MakePopup()
end

function PANEL:Paint(w,h)
    Derma_DrawBackgroundBlur( self, self.starTime )

    HZNShadows.BeginShadow( "HZNPrestige:Confirmation" )
    local x, y = self:LocalToScreen( 0, 0 )
    draw.RoundedBox(0, x, y, w, h, HZNPrestige.Colors["DashboardHeader"])
    -- draw assure text
    draw.DrawText(self.assureText, "HZNPrestige:B:20", x+w/2, y+sh(10), Color(255, 255, 255), 1)
    HZNShadows.EndShadow( "HZNPrestige:Confirmation", x, y, 1, 1, 1, 255, 0, 0, false )
end

function PANEL:SetApproveCallback(func)
    self.approveBtn.DoClick = function(self)
        if (self:GetParent().readyToGo) then
            func()
            self:GetParent():Remove()
        end
    end
end

vgui.Register("HZNPresitge:Confirm", PANEL, "DFrame")