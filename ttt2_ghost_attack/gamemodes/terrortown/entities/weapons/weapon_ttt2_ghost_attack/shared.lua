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

SWEP.Author = "mexikoedi"
SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "slam"
SWEP.PrintName = "Ghost Attack"
SWEP.UseHands = true
SWEP.Kind = WEAPON_EQUIP1
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
    if CLIENT then
        self:AddHUDHelp("ttt2_ghost_attack_help1", "ttt2_ghost_attack_help2", true)
    end
end

function SWEP:PrimaryAttack()
    if SERVER then
        if not self:CanPrimaryAttack() then return end
        ghostowner1 = self:GetOwner()
        ghostownerteam1 = ghostowner1:GetTeam()

        if ghostattackstarted == true then
            ghostowner1:ChatPrint("Wait until the first ghost attack is finished!")

            return
        end

        if GetConVar("ttt2_ghost_attack_primary_sound"):GetBool() then
            ghostowner1:EmitSound("ghost_attack1.wav")
            ghostattackstarted = true
        end

        timer.Create("GhostAttackStart", 0.8, 1, function()
            for _, ghostvictim1 in ipairs(player.GetAll()) do
                if ghostattackstarted == true and ghostvictim1:Alive() and not (ghostvictim1.IsGhost and ghostvictim1:IsGhost()) and not ghostvictim1:IsSpec() and ghostvictim1:GetTeam() ~= ghostownerteam1 and GetRoundState() == ROUND_ACTIVE and GetRoundState() ~= ROUND_PREP and GetRoundState() ~= ROUND_WAIT then
                    if GetConVar("ttt2_ghost_attack_arrival_sound"):GetBool() then
                        ghostvictim1:EmitSound("ghost_attack3.wav")
                    end

                    if GetConVar("ttt2_ghost_attack_arrival_popup"):GetBool() then
                        net.Start("ttt2_ghost_attack_epop_1")
                        net.Send(ghostvictim1)
                    end

                    net.Start("ghosts")
                    net.Send(ghostvictim1)
                end
            end
        end)

        self:TakePrimaryAmmo(1)

        if self:Clip1() <= 0 then
            self:Remove()
        end

        timer.Create("GhostAttackTime", GetConVar("ttt2_ghost_attack_ghosts_duration"):GetInt(), 1, function()
            for _, ghostvictim2 in ipairs(player.GetAll()) do
                if ghostattackstarted == true and ghostvictim2:Alive() and not (ghostvictim2.IsGhost and ghostvictim2:IsGhost()) and not ghostvictim2:IsSpec() and ghostvictim2:GetTeam() ~= ghostownerteam1 and GetRoundState() == ROUND_ACTIVE and GetRoundState() ~= ROUND_PREP and GetRoundState() ~= ROUND_WAIT then
                    if GetConVar("ttt2_ghost_attack_departure_sound"):GetBool() then
                        ghostvictim2:EmitSound("ghost_attack4.wav")
                    end

                    if GetConVar("ttt2_ghost_attack_departure_popup"):GetBool() then
                        net.Start("ttt2_ghost_attack_epop_2")
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
end

timer.Remove("GhostAttackStart")
timer.Remove("GhostAttackTime")
timer.Remove("GhostAttackSoundRemoval")

if SERVER then
    SWEP.NextSecondaryAttack = 0

    function SWEP:SecondaryAttack()
        if self.NextSecondaryAttack > CurTime() then return end
        self.currentOwner = self:GetOwner()
        self.NextSecondaryAttack = CurTime() + self.Secondary.Delay

        if GetConVar("ttt2_ghost_attack_secondary_sound"):GetBool() and not self.LoopSound then
            self.LoopSound = CreateSound(self.currentOwner, Sound(song_path .. songs[math.random(#songs)]))

            if (self.LoopSound) then
                self.LoopSound:Play()
            end
        end
    end

    function SWEP:KillSounds()
        if (self.LoopSound) then
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
        if IsValid(self.currentOwner) then
            self:KillSounds()
        end

        return true
    end

    function SWEP:OnDrop()
        if IsValid(self.currentOwner) then
            self:KillSounds()
        end

        self:Remove()
    end
end

if CLIENT then
    net.Receive("ttt2_ghost_attack_epop_1", function()
        EPOP:AddMessage({
            text = LANG.GetTranslation("ttt2_ghost_attack_popuptitle_1"),
            color = Color(212, 209, 217, 255)
        }, "", GetConVar("ttt2_ghost_attack_arrival_popup_duration"):GetInt())
    end)

    net.Receive("ttt2_ghost_attack_epop_2", function()
        EPOP:AddMessage({
            text = LANG.GetTranslation("ttt2_ghost_attack_popuptitle_2"),
            color = Color(212, 209, 217, 255)
        }, "", GetConVar("ttt2_ghost_attack_departure_popup_duration"):GetInt())
    end)

    net.Receive("ghosts", function()
        timer.Create("GhostAttackGraphics", 0.8, 1, function()
            hook.Add("RenderScreenspaceEffects", "GhostAttack", function()
                DrawMaterialOverlay("ghost/ghosts", 0)
            end)
        end)

        timer.Create("GhostAttackGraphicsRemoval", GetConVar("ttt2_ghost_attack_ghosts_duration"):GetInt(), 1, function()
            hook.Remove("RenderScreenspaceEffects", "GhostAttack")
        end)
    end)
end

timer.Remove("GhostAttackGraphics")
timer.Remove("GhostAttackGraphicsRemoval")
