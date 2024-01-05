-- convars added with default values
CreateConVar("ttt2_ghost_attack_primary_sound", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the primary attack")
CreateConVar("ttt2_ghost_attack_secondary_sound", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the secondary attack")
CreateConVar("ttt2_ghost_attack_arrival_sound", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the ghost arrival")
CreateConVar("ttt2_ghost_attack_departure_sound", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the ghost departure")
CreateConVar("ttt2_ghost_attack_arrival_popup", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Popup because of the ghost arrival")
CreateConVar("ttt2_ghost_attack_arrival_popup_duration", "5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Popup duration of the arrival popup")
CreateConVar("ttt2_ghost_attack_departure_popup", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Popup because of the ghost departure")
CreateConVar("ttt2_ghost_attack_departure_popup_duration", "5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Popup duration of the departure popup")
CreateConVar("ttt2_ghost_attack_ghosts_duration", "15", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Ghost attack duration")
if CLIENT then
    -- Use string or string.format("%.f",<steamid64>) 
    -- addon dev emblem in scoreboard
    hook.Add("TTT2FinishedLoading", "TTT2RegistermexikoediAddonDev", function() AddTTT2AddonDev("76561198279816989") end)
end