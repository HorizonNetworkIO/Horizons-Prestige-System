local PANEL = {}

local sw = function(v) return ((ScrW() * v)/1920) end
local sh = function(v) return ((ScrH() * v)/1080) end


function PANEL:Init()

end

function PANEL:Setup()
    if self.scrollboard then
        self.scrollboard:Remove()
    end

    self.scrollboard = vgui.Create("DScrollPanel", self)
    self.scrollboard:SetSize(self:GetWide(), self:GetTall())
    self.scrollboard:SetPos(0, 0)

    local scrollbar = self.scrollboard:GetVBar()
    function scrollbar:Paint(w, h) end
    function scrollbar.btnUp:Paint(w, h) end
    function scrollbar.btnDown:Paint(w, h) end
    function scrollbar.btnGrip:Paint(w, h)
        draw.RoundedBox(2, w/2 - sw(2.5), 0, sw(5), h, HZNPrestige.Colors["TextColor"])
    end

    for k,v in ipairs(HZNPrestige.Scoreboard) do
        local steamID = v.steamid
        local steamID64 = util.SteamIDTo64(steamID)
        local name = steamID
        steamworks.RequestPlayerInfo(steamID64, function(playerName)
            name = playerName
        end)
        local points = v.points

        self.score = vgui.Create("DPanel", self.scrollboard)
        self.score:SetTall(sh(40))
        self.score:DockMargin(sw(2.5), sh(2.5), sw(2.5), sh(2.5))
        self.score:Dock(TOP)
        self.score.Paint = function(s, w, h)
            draw.RoundedBox(2, 0, 0, w, h, HZNPrestige.Colors["Button"])
            HZNPrestige:DrawText(tostring(k) .. ". " .. name, "HZNPrestige:B:25", sw(10), h/2, color_white, TEXT_ALIGN_LEFT, 1, 2, 255)
            HZNPrestige:DrawText(points .. "p", "HZNPrestige:B:20", w - sw(10), h/2, color_white, TEXT_ALIGN_RIGHT, 1, 2, 255)
        end
    end
    
end

function PANEL:Paint()
    
end

vgui.Register("HZNPrestige:Scoreboard", PANEL, "DPanel")