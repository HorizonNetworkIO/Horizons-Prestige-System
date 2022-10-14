local PANEL = {}

local animation_time = 0.25

local sw = function(v) return ((ScrW() * v)/1920) end
local sh = function(v) return ((ScrH() * v)/1080) end

local get_wide = function(pnl) return (pnl:GetWide()/3) end
local get_x_pos = function(pnl,id) return (get_wide(pnl)*id-get_wide(pnl)) end

function PANEL:Init()
    self.curBtn = 1
    self.btns = {}

    self.dashBtn = vgui.Create("DButton", self)
    table.insert(self.btns, self.dashBtn)

    self.scoreBtn = vgui.Create("DButton", self)
    table.insert(self.btns, self.scoreBtn)

    self.shopBtn = vgui.Create("DButton", self)
    table.insert(self.btns, self.shopBtn)

    for k,v in ipairs(self.btns) do
        local selectedBtn = (self.curBtn == k)
        v.btnLerp = 0

        v:SetText("")

        v.DoClick = function()
            self.curBtn = k
            self:CallCallback()
        end

        function v:Paint(w, h)
            local selectedBtn = (self:GetParent().curBtn == k)
            local font = (selectedBtn) and "HZNPrestige:B:20" or "HZNPrestige:N:20"
            local navText = (k == 1) and "Trade In" or (k == 2) and "Scoreboard" or "Shop"
            local col = (selectedBtn) and HZNPrestige.Colors["SelectedButton"] or HZNPrestige.Colors["TextColor"]

            self.btnLerp = 0

            if (!self.startLerpTime) then
                self.startLerpTime = SysTime()
            end

            self.btnLerp = Lerp((SysTime() - self.startLerpTime)/animation_time, self.btnLerp, 10)

            draw.SimpleText(navText, font, w/2, h/2, col, 1, 1)

            if (self:IsHovered()) then
                if (!self.startHover) then
                    self.startHover = SysTime()
                end

                if (!selectedBtn) then
                    self.btnLerp = Lerp((SysTime() - self.startHover) / animation_time, self.btnLerp, 5)
                else
                    self.btnLerp = Lerp((SysTime() - self.startHover) / animation_time, self.btnLerp, 10)
                end
                surface.SetDrawColor(HZNPrestige.Colors["SelectedButton"])
                draw.RoundedBox(10, sw(self.btnLerp), sh(38), w - sw(self.btnLerp*2), sh(2), HZNPrestige.Colors["SelectedButton"])
            else
                if (self.startHover) then
                    self.startHover = nil
                end

                 if (selectedBtn) then
                    self.btnLerp = Lerp((SysTime() - self.startLerpTime) / animation_time, self.btnLerp, 10)
                    surface.SetDrawColor(HZNPrestige.Colors["SelectedButton"])
                    draw.RoundedBox(10, sw(self.btnLerp), sh(38), w - sw(self.btnLerp*2), sh(2), HZNPrestige.Colors["SelectedButton"])
                 end
            end



            -- if (!self:IsHovered()) then
            --     if (selectedBtn) then
            --         surface.SetDrawColor(HZNPrestige.Colors["SelectedButton"])
            --         draw.RoundedBox(10, sw(self.btnLerp), sh(38), w - sw(self.btnLerp*2), sh(2), HZNPrestige.Colors["SelectedButton"])
            --     end
            -- else
            --     if (!self.startHover) then
            --         self.startHover = SysTime()
            --     end

            --     self.btnLerp = Lerp(SysTime() - self.startHover, self.btnLerp, 10)
                
            --     if (!selectedBtn) then
            --         surface.SetDrawColor(HZNPrestige.Colors["SelectedButton"])
            --         draw.RoundedBox(10, sw(self.btnLerp*2), sh(38), w - sw(self.btnLerp*4), sh(2), HZNPrestige.Colors["SelectedButton"])
            --     else
            --         surface.SetDrawColor(HZNPrestige.Colors["SelectedButton"])
            --         draw.RoundedBox(10, sw(self.btnLerp), sh(38), w - sw(self.btnLerp*2), sh(2), HZNPrestige.Colors["SelectedButton"])
            --     end
            -- end
        end
    end
end

function PANEL:SetMyID(id)
    self.curBtn = id
end

function PANEL:CallCallback()
    if (self.callback) then
        self.callback(self.curBtn)
    end
end

function PANEL:Setup()
    local wide = get_wide(self)
    local tall = self:GetTall()

    self.shopBtn:SetSize(wide, tall)
    self.shopBtn:SetPos(get_x_pos(self, 3), 0)

    self.scoreBtn:SetSize(wide, tall)
    self.scoreBtn:SetPos(get_x_pos(self, 2), 0)

    self.dashBtn:SetSize(wide, tall)
    self.dashBtn:SetPos(get_x_pos(self, 1), 0)
end

function PANEL:Paint(w,h)
    draw.RoundedBox(0, 0, 0, w, h, HZNPrestige.Colors["Button"])
    -- draw.RoundedBox(0, 0, self:GetTall()-sh(2), w, sh(2), HZNPrestige.Colors["CloseButton"])
    -- draw.RoundedBox(0, 0, 0, w, sh(2), HZNPrestige.Colors["CloseButton"])
end

function PANEL:SetMyCallback(callback)
    self.callback = callback
end



vgui.Register("HZNPrestige:Navbar", PANEL, "DPanel")