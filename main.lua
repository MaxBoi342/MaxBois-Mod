---
--- Instantiate atlases that need to be used
---

SMODS.Atlas({
    key = "Lingo2Glyphs",
    path = "Lingo2Glyphs.png",
    px = 96,
    py = 96,
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomJokers",
    path = "CustomJokers.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomConsumables",
    path = "CustomConsumables.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomEnhancements",
    path = "CustomEnhancements.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomSeals",
    path = "CustomSeals.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
}):register()

---
---Instantiate MaxBoiSM as global variable storage and related tables
---

if not MaxBoiSM then
    MaxBoiSM = {}
end

if not MaxBoiSM.ENTERED_LINGO_WORD then --lingo 1 consumable
    MaxBoiSM.ENTERED_LINGO_WORD = ''
end

if not MaxBoiSM.ENTERED_LINGO2_WORD then --lingo 2 consumable
    MaxBoiSM.ENTERED_LINGO2_WORD = ''
end

-- lingo 2 glyphs




-- lingo 1 colors
if not MaxBoiSM.COLORS then
    MaxBoiSM.COLORS = {
        RD = HEX('FF0000'), --1
        BL = HEX('0000FF'), --2
        YE = HEX('ffef00'), --3
        WH = HEX('FFFFFF'), --4
        BK = HEX('000000'), --5
        PU = HEX('7A1B7A'), --6
        BR = HEX('593B0C'), --7
        MA = HEX('E60283'), --8
        LI = HEX('00FF00'), --9
        LA = HEX('B2A4D4'), --10
        OR = HEX('F96815'), -- this one might be evil
        GR = HEX('004225'), -- evil 2
        MI = HEX('5ec7a1'), -- evil 3
        XX = HEX('555555'), -- disabled
    }
end

MaxBoiSM.path = '' .. SMODS.current_mod.path



--janky hack to let sand cards show their rank (otherwise same as SMODS.Enhancement)
SMODS.MaxBoi_Enhancement = SMODS.Center:extend {
    set = 'Enhanced',
    class_prefix = 'm',
    atlas = 'centers',
    pos = { x = 0, y = 0 },
    required_params = {
        'key',
    },
    register = function(self)
        self.config = self.config or {}
        assert(not (self.no_suit and self.any_suit),
            "Cannot have both \"no_suit\" and \"any_suit\" defined in a SMODS.Enhancement object.")
        SMODS.Enhancement.super.register(self)     --only actual difference is the removal of a line here
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local always_show = self.config and self.config.always_show or {}
        if specific_vars and specific_vars.nominal_chips and not self.replace_base_card then
            localize { type = 'other', key = 'card_chips', nodes = desc_nodes, vars = { specific_vars.nominal_chips } }
        end
        SMODS.MaxBoi_Enhancement.super.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if specific_vars and specific_vars.bonus_chips then
            local remaining_bonus_chips = specific_vars.bonus_chips - (self.config.bonus or 0)
            if remaining_bonus_chips ~= 0 then
                localize { type = 'other', key = 'card_extra_chips', nodes = desc_nodes, vars = { SMODS.signed(remaining_bonus_chips) } }
            end
        end
        if specific_vars and specific_vars.bonus_x_chips then
            localize { type = 'other', key = 'card_x_chips', nodes = desc_nodes, vars = { specific_vars.bonus_x_chips } }
        end
        if specific_vars and specific_vars.bonus_mult then
            localize { type = 'other', key = 'card_extra_mult', nodes = desc_nodes, vars = { SMODS.signed(specific_vars.bonus_mult) } }
        end
        if specific_vars and specific_vars.bonus_x_mult then
            localize { type = 'other', key = 'card_x_mult', nodes = desc_nodes, vars = { specific_vars.bonus_x_mult } }
        end
        if specific_vars and specific_vars.bonus_h_chips then
            localize { type = 'other', key = 'card_extra_h_chips', nodes = desc_nodes, vars = { SMODS.signed(specific_vars.bonus_h_chips) } }
        end
        if specific_vars and specific_vars.bonus_x_chips then
            localize { type = 'other', key = 'card_h_x_chips', nodes = desc_nodes, vars = { specific_vars.bonus_h_x_chips } }
        end
        if specific_vars and specific_vars.bonus_h_mult then
            localize { type = 'other', key = 'card_extra_h_mult', nodes = desc_nodes, vars = { SMODS.signed(specific_vars.bonus_h_mult) } }
        end
        if specific_vars and specific_vars.bonus_h_x_mult then
            localize { type = 'other', key = 'card_h_x_mult', nodes = desc_nodes, vars = { specific_vars.bonus_h_x_mult } }
        end
        if specific_vars and specific_vars.bonus_p_dollars then
            localize { type = 'other', key = 'card_extra_p_dollars', nodes = desc_nodes, vars = { SMODS.signed_dollars(specific_vars.bonus_p_dollars) } }
        end
        if specific_vars and specific_vars.bonus_h_dollars then
            localize { type = 'other', key = 'card_extra_h_dollars', nodes = desc_nodes, vars = { SMODS.signed_dollars(specific_vars.bonus_h_dollars) } }
        end
    end,
}


local NFS = require("nativefs")
to_big = to_big or function(a) return a end
lenient_bignum = lenient_bignum or function(a) return a end


local function load_utils_folder()
    local mod_path = SMODS.current_mod.path
    local consumables_path = mod_path .. "/utils"
    local files = NFS.getDirectoryItemsInfo(consumables_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("utils/" .. file_name))()
        end
    end
end

load_utils_folder()

local function load_jokers_folder()
    local mod_path = SMODS.current_mod.path
    local jokers_path = mod_path .. "/jokers"
    local files = NFS.getDirectoryItemsInfo(jokers_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("jokers/" .. file_name))()
        end
    end
end

local function load_consumables_folder()
    local mod_path = SMODS.current_mod.path
    local consumables_path = mod_path .. "/consumables"
    local files = NFS.getDirectoryItemsInfo(consumables_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("consumables/" .. file_name))()
        end
    end
end

local function load_enhancements_folder()
    local mod_path = SMODS.current_mod.path
    local consumables_path = mod_path .. "/enhancements"
    local files = NFS.getDirectoryItemsInfo(consumables_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("enhancements/" .. file_name))()
        end
    end
end

local function load_editions_folder()
    local mod_path = SMODS.current_mod.path
    local consumables_path = mod_path .. "/editions"
    local files = NFS.getDirectoryItemsInfo(consumables_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("editions/" .. file_name))()
        end
    end
end

local function load_seals_folder()
    local mod_path = SMODS.current_mod.path
    local consumables_path = mod_path .. "/seals"
    local files = NFS.getDirectoryItemsInfo(consumables_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("seals/" .. file_name))()
        end
    end
end

load_jokers_folder()
load_consumables_folder()
load_enhancements_folder()
load_editions_folder()
load_seals_folder()
