CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_addons_ghost_attack_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_addons_ghost_attack")

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