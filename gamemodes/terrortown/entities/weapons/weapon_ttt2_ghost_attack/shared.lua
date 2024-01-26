local songs = {}
local song_path = "secondary/"
if SERVER then
    AddCSLuaFile()
    resource.AddFile("materials/vgui/ttt/weapon_ghost_attack.vmt")
    resource.AddFile("materials/ghost/ghosts.vmt")
    resource.AddFile("sound/ghost_attack1.wav")
    resource.AddFile("sound/ghost_attack3.wav")
    resource.AddFile("sound/ghost_attack4.wav")
    local song_files = file.Find("sound/" .. song_path .. "*.wav", "GAME")
    if song_files then
        for i = 1, #song_files do
            local song = song_files[i]
            resource.AddFile("sound/" .. song_path .. song_files[i])
            songs[i] = song
        end
    end

    util.AddNetworkString("ttt2_ghost_attack_epop_1")
    util.AddNetworkString("ttt2_ghost_attack_epop_2")
    util.AddNetworkString("ghosts")
end

SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "slam"
SWEP.Author = "mexikoedi"
SWEP.PrintName = "Ghost Attack"
SWEP.Contact = "Steam"
SWEP.Instructions = "Left click to spawn ghost on everyones hud and secondary attack to play random sounds."
SWEP.Purpose = "Call ghost which will haunt the living players."
SWEP.UseHands = true
SWEP.Kind = WEAPON_EQUIP1
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.AdminSpawnable = false
SWEP.AutoSpawnable = false
SWEP.Slot = 7
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.AllowDrop = false
SWEP.AllowPickup = false
SWEP.InLoadoutFor = nil
SWEP.IsSilent = false
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Secondary.Delay = 1
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true
SWEP.Icon = "vgui/ttt/weapon_ghost_attack"
SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "ttt2_ghost_attack_name",
    desc = "ttt2_ghost_attack_desc"
}

function SWEP:Initialize()
    if CLIENT then self:AddHUDHelp("ttt2_ghost_attack_help1", "ttt2_ghost_attack_help2", true) end
end

if SERVER then
    function SWEP:PrimaryAttack()
        if not self:CanPrimaryAttack() then return end
        ghostowner1 = self:GetOwner()
        ghostownerteam1 = ghostowner1:GetTeam()
        if GetRoundState() ~= ROUND_ACTIVE then
            ghostowner1:ChatPrint("Round is not active, you can't use this weapon!")
            return
        end

        if ghostattackstarted == true then
            ghostowner1:ChatPrint("Wait until the first ghost attack is finished!")
            return
        end

        if GetConVar("ttt2_ghost_attack_primary_sound"):GetBool() then ghostowner1:EmitSound("ghost_attack1.wav") end
        ghostattackstarted = true
        timer.Create("GhostAttackStart", 0.8, 1, function()
            for _, ghostvictim1 in ipairs(player.GetAll()) do
                if ghostattackstarted == true and ghostvictim1:IsActive() and ghostvictim1:GetTeam() ~= ghostownerteam1 and not (ghostvictim1.IsGhost and ghostvictim1:IsGhost()) then
                    if GetConVar("ttt2_ghost_attack_arrival_sound"):GetBool() then ghostvictim1:EmitSound("ghost_attack3.wav") end
                    if GetConVar("ttt2_ghost_attack_arrival_popup"):GetBool() then
                        net.Start("ttt2_ghost_attack_epop_1")
                        net.WriteInt(GetConVar("ttt2_ghost_attack_arrival_popup_duration"):GetInt(), 32)
                        net.Send(ghostvictim1)
                    end

                    net.Start("ghosts")
                    net.WriteInt(GetConVar("ttt2_ghost_attack_ghosts_duration"):GetInt(), 32)
                    net.Send(ghostvictim1)
                end
            end
        end)

        self:TakePrimaryAmmo(1)
        if self:Clip1() <= 0 then self:Remove() end
        timer.Create("GhostAttackTime", GetConVar("ttt2_ghost_attack_ghosts_duration"):GetInt(), 1, function()
            for _, ghostvictim2 in ipairs(player.GetAll()) do
                if ghostattackstarted == true and ghostvictim2:IsActive() and ghostvictim2:GetTeam() ~= ghostownerteam1 and not (ghostvictim2.IsGhost and ghostvictim2:IsGhost()) then
                    if GetConVar("ttt2_ghost_attack_departure_sound"):GetBool() then ghostvictim2:EmitSound("ghost_attack4.wav") end
                    if GetConVar("ttt2_ghost_attack_departure_popup"):GetBool() then
                        net.Start("ttt2_ghost_attack_epop_2")
                        net.WriteInt(GetConVar("ttt2_ghost_attack_departure_popup_duration"):GetInt(), 32)
                        net.Send(ghostvictim2)
                    end
                end
            end
        end)

        timer.Create("GhostAttackSoundRemoval", GetConVar("ttt2_ghost_attack_ghosts_duration"):GetInt() + 8, 1, function()
            for _, ghostvictim3 in ipairs(player.GetAll()) do
                ghostvictim3:StopSound("ghost_attack4.wav")
                ghostattackstarted = false
            end
        end)
    end

    SWEP.NextSecondaryAttack = 0
    function SWEP:SecondaryAttack()
        if self.NextSecondaryAttack > CurTime() then return end
        self.currentOwner = self:GetOwner()
        self.NextSecondaryAttack = CurTime() + self.Secondary.Delay
        if GetConVar("ttt2_ghost_attack_secondary_sound"):GetBool() and not self.LoopSound then
            self.LoopSound = CreateSound(self.currentOwner, Sound(song_path .. songs[math.random(#songs)]))
            if self.LoopSound then self.LoopSound:Play() end
        end
    end

    function SWEP:KillSounds()
        if self.LoopSound then
            self.LoopSound:Stop()
            self.LoopSound = nil
        end
    end

    function SWEP:OnRemove()
        if IsValid(self.currentOwner) then
            self:KillSounds()
            self.currentOwner:ConCommand("lastinv")
        end
    end

    function SWEP:Holster()
        if IsValid(self.currentOwner) then self:KillSounds() end
        return true
    end

    function SWEP:OnDrop()
        if IsValid(self.currentOwner) then self:KillSounds() end
        self:Remove()
    end
end

if CLIENT then
    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")
        form:MakeCheckBox({
            serverConvar = "ttt2_ghost_attack_primary_sound",
            label = "label_ghost_attack_primary_sound"
        })

        form:MakeCheckBox({
            serverConvar = "ttt2_ghost_attack_secondary_sound",
            label = "label_ghost_attack_secondary_sound"
        })

        form:MakeCheckBox({
            serverConvar = "ttt2_ghost_attack_arrival_sound",
            label = "label_ghost_attack_arrival_sound"
        })

        form:MakeCheckBox({
            serverConvar = "ttt2_ghost_attack_departure_sound",
            label = "label_ghost_attack_departure_sound"
        })

        form:MakeCheckBox({
            serverConvar = "ttt2_ghost_attack_arrival_popup",
            label = "label_ghost_attack_arrival_popup"
        })

        form:MakeSlider({
            serverConvar = "ttt2_ghost_attack_arrival_popup_duration",
            label = "label_ghost_attack_arrival_popup_duration",
            min = 0,
            max = 15,
            decimal = 0
        })

        form:MakeCheckBox({
            serverConvar = "ttt2_ghost_attack_departure_popup",
            label = "label_ghost_attack_departure_popup"
        })

        form:MakeSlider({
            serverConvar = "ttt2_ghost_attack_departure_popup_duration",
            label = "label_ghost_attack_departure_popup_duration",
            min = 0,
            max = 15,
            decimal = 0
        })

        form:MakeSlider({
            serverConvar = "ttt2_ghost_attack_ghosts_duration",
            label = "label_ghost_attack_ghosts_duration",
            min = 0,
            max = 30,
            decimal = 0
        })
    end

    net.Receive("ttt2_ghost_attack_epop_1", function()
        ghost_attack_duration1 = net.ReadInt(32)
        EPOP:AddMessage({
            text = LANG.GetTranslation("ttt2_ghost_attack_popuptitle_1"),
            color = Color(212, 209, 217, 255)
        }, "", ghost_attack_duration1)
    end)

    net.Receive("ttt2_ghost_attack_epop_2", function()
        ghost_attack_duration2 = net.ReadInt(32)
        EPOP:AddMessage({
            text = LANG.GetTranslation("ttt2_ghost_attack_popuptitle_2"),
            color = Color(212, 209, 217, 255)
        }, "", ghost_attack_duration2)
    end)

    net.Receive("ghosts", function()
        ghost_attack_duration3 = net.ReadInt(32)
        timer.Create("GhostAttackGraphics", 0.8, 1, function() hook.Add("RenderScreenspaceEffects", "GhostAttack", function() DrawMaterialOverlay("ghost/ghosts", 0) end) end)
        timer.Create("GhostAttackGraphicsRemoval", ghost_attack_duration3, 1, function() hook.Remove("RenderScreenspaceEffects", "GhostAttack") end)
    end)
end

timer.Remove("GhostAttackStart")
timer.Remove("GhostAttackTime")
timer.Remove("GhostAttackSoundRemoval")
timer.Remove("GhostAttackGraphics")
timer.Remove("GhostAttackGraphicsRemoval")