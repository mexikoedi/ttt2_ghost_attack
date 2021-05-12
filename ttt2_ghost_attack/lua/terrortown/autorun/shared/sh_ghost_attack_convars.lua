-- convars added with default values
CreateConVar("ttt2_ghost_attack_primary_sound", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the primary attack")

CreateConVar("ttt2_ghost_attack_secondary_sound", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the secondary attack")

CreateConVar("ttt2_ghost_attack_arrival_sound", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the ghost arrival")

CreateConVar("ttt2_ghost_attack_departure_sound", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the ghost departure")

CreateConVar("ttt2_ghost_attack_arrival_popup", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Popup because of the ghost arrival")

CreateConVar("ttt2_ghost_attack_arrival_popup_duration", "5", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Popup duration of the arrival popup")

CreateConVar("ttt2_ghost_attack_departure_popup", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Popup because of the ghost departure")

CreateConVar("ttt2_ghost_attack_departure_popup_duration", "5", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Popup duration of the departure popup")

CreateConVar("ttt2_ghost_attack_ghosts_duration", "15", {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Ghost attack duration")

if CLIENT then
    -- Use string or string.format("%.f",<steamid64>) 
    -- addon dev emblem in scoreboard
    hook.Add("TTT2FinishedLoading", "TTT2RegistermexikoediAddonDev", function()
        AddTTT2AddonDev("76561198279816989")
    end)
end

hook.Add("TTTUlxInitCustomCVar", "TTT2GhostAttackInitRWCVar", function(name)
    ULib.replicatedWritableCvar("ttt2_ghost_attack_primary_sound", "rep_ttt2_ghost_attack_primary_sound", GetConVar("ttt2_ghost_attack_primary_sound"):GetBool(), true, false, name)
    ULib.replicatedWritableCvar("ttt2_ghost_attack_secondary_sound", "rep_ttt2_ghost_attack_secondary_sound", GetConVar("ttt2_ghost_attack_secondary_sound"):GetBool(), true, false, name)
    ULib.replicatedWritableCvar("ttt2_ghost_attack_arrival_sound", "rep_ttt2_ghost_attack_arrival_sound", GetConVar("ttt2_ghost_attack_arrival_sound"):GetBool(), true, false, name)
    ULib.replicatedWritableCvar("ttt2_ghost_attack_departure_sound", "rep_ttt2_ghost_attack_departure_sound", GetConVar("ttt2_ghost_attack_departure_sound"):GetBool(), true, false, name)
    ULib.replicatedWritableCvar("ttt2_ghost_attack_arrival_popup", "rep_ttt2_ghost_attack_arrival_popup", GetConVar("ttt2_ghost_attack_arrival_popup"):GetBool(), true, false, name)
    ULib.replicatedWritableCvar("ttt2_ghost_attack_arrival_popup_duration", "rep_ttt2_ghost_attack_arrival_popup_duration", GetConVar("ttt2_ghost_attack_arrival_popup_duration"):GetInt(), true, false, name)
    ULib.replicatedWritableCvar("ttt2_ghost_attack_departure_popup", "rep_ttt2_ghost_attack_departure_popup", GetConVar("ttt2_ghost_attack_departure_popup"):GetBool(), true, false, name)
    ULib.replicatedWritableCvar("ttt2_ghost_attack_departure_popup_duration", "rep_ttt2_ghost_attack_departure_popup_duration", GetConVar("ttt2_ghost_attack_departure_popup_duration"):GetInt(), true, false, name)
    ULib.replicatedWritableCvar("ttt2_ghost_attack_ghosts_duration", "rep_ttt2_ghost_attack_ghosts_duration", GetConVar("ttt2_ghost_attack_ghosts_duration"):GetInt(), true, false, name)
end)

if CLIENT then
    hook.Add("TTTUlxModifyAddonSettings", "TTT2GhostAttackModifySettings", function(name)
        local tttrspnl = xlib.makelistlayout{
            w = 415,
            h = 318,
            parent = xgui.null
        }

        -- Basic Settings
        local tttrsclp1 = vgui.Create("DCollapsibleCategory", tttrspnl)
        tttrsclp1:SetSize(390, 190)
        tttrsclp1:SetExpanded(1)
        tttrsclp1:SetLabel("Basic Settings")
        local tttrslst1 = vgui.Create("DPanelList", tttrsclp1)
        tttrslst1:SetPos(5, 25)
        tttrslst1:SetSize(390, 190)
        tttrslst1:SetSpacing(5)

        tttrslst1:AddItem(xlib.makecheckbox{
            label = "ttt2_ghost_attack_primary_sound (Def. 1)",
            repconvar = "rep_ttt2_ghost_attack_primary_sound",
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makecheckbox{
            label = "ttt2_ghost_attack_secondary_sound (Def. 1)",
            repconvar = "rep_ttt2_ghost_attack_secondary_sound",
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makecheckbox{
            label = "ttt2_ghost_attack_arrival_sound (Def. 1)",
            repconvar = "rep_ttt2_ghost_attack_arrival_sound",
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makecheckbox{
            label = "ttt2_ghost_attack_departure_sound (Def. 1)",
            repconvar = "rep_ttt2_ghost_attack_departure_sound",
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makecheckbox{
            label = "ttt2_ghost_attack_arrival_popup (Def. 1)",
            repconvar = "rep_ttt2_ghost_attack_arrival_popup",
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makeslider{
            label = "ttt2_ghost_attack_arrival_popup_duration (Def. 5)",
            repconvar = "rep_ttt2_ghost_attack_arrival_popup_duration",
            min = 0,
            max = 15,
            decimal = 0,
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makecheckbox{
            label = "ttt2_ghost_attack_departure_popup (Def. 1)",
            repconvar = "rep_ttt2_ghost_attack_departure_popup",
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makeslider{
            label = "ttt2_ghost_attack_departure_popup_duration (Def. 5)",
            repconvar = "rep_ttt2_ghost_attack_departure_popup_duration",
            min = 0,
            max = 15,
            decimal = 0,
            parent = tttrslst1
        })

        tttrslst1:AddItem(xlib.makeslider{
            label = "ttt2_ghost_attack_ghosts_duration (Def. 15)",
            repconvar = "rep_ttt2_ghost_attack_ghosts_duration",
            min = 0,
            max = 30,
            decimal = 0,
            parent = tttrslst1
        })

        -- add to ULX
        xgui.hookEvent("onProcessModules", nil, tttrspnl.processModules)
        xgui.addSubModule("Ghost Attack", tttrspnl, nil, name)
    end)
end