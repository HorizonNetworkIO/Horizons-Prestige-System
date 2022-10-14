// Steel's Addon Loader
// Fuck off

local AddonSubFolder = "prestige"
local AddonName = "Prestige"
local AddonColor = Color(61, 185, 226)
local DebugAddon = true

HZNPrestige = {}

function HZNPrestige:Log(str)
    MsgC(AddonColor, "[" .. AddonName .. "] ", Color(255, 255, 255), str .. "\n")
end

local function loadServerFile(str)
    if CLIENT then return end
    include(str)
    HZNPrestige:Log("Loaded Server File " .. str)
end

local function loadClientFile(str)
    if SERVER then AddCSLuaFile(str) return end
    include(str)
    HZNPrestige:Log("Loaded Client File " .. str)
end

local function loadSharedFile(str)
    if SERVER then AddCSLuaFile(str) end
    include(str)
    HZNPrestige:Log("Loaded Shared File " .. str)
end

local function load()
    local sharedFiles = file.Find(AddonSubFolder .. "/sh/*.lua", "LUA")
    local clientFiles = file.Find(AddonSubFolder .. "/cl/*.lua", "LUA")
    local vguiFiles = file.Find(AddonSubFolder .. "/cl/vgui/*.lua", "LUA")
    local serverFiles = file.Find(AddonSubFolder .. "/sv/*.lua", "LUA")

    for _, file in pairs(clientFiles) do
        loadClientFile(AddonSubFolder .. "/cl/" .. file)
    end

    for _, file in pairs(sharedFiles) do
        loadSharedFile(AddonSubFolder .. "/sh/" .. file)
    end

    for _, file in pairs(serverFiles) do
        loadServerFile(AddonSubFolder .. "/sv/" .. file)
    end

    for _, file in pairs(vguiFiles) do
        loadClientFile(AddonSubFolder .. "/cl/vgui/" .. file)
    end

    HZNPrestige:Log("Loaded " .. #clientFiles + #sharedFiles + #serverFiles + #vguiFiles .. " files")

    if (SERVER) then
        HZNPrestige.Data:InitializeDatabase()
        timer.Simple(1, function()
            HZNPrestige:LoadItems()
        end)

        if (DebugAddon and player.GetCount() > 0) then
            for k,v in ipairs(player.GetAll()) do
                HZNPrestige.Data:LoadPlayer(v)
            end
        end
    end
end

load()