local NFS = require("nativefs")

---
--- Instantiate atlases that need to be used
---

to_big = to_big or function(a) return a end
lenient_bignum = lenient_bignum or function(a) return a end
to_number = to_number or function(a) return a end

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

SMODS.Atlas({
    key = "CustomStickers",
    path = "CustomStickers.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomBackstickers",
    path = "CustomBackstickers.png",
    px = 29,
    py = 29,
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomBoosters",
    path = "CustomBoosters.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomDecks",
    path = "CustomDecks.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomBlinds",
    path = "CustomBlinds.png",
    px = 34,
    py = 34,
    frames = 21,
    atlas_table = "ANIMATION_ATLAS"
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

if not MaxBoiSM.DISABLE_MONEY_REPEATS then
    MaxBoiSM.DISABLE_MONEY_REPEATS = false
end
if not MaxBoiSM.shared_backstickers then
    MaxBoiSM.shared_backstickers = {}
end

MaxBoiSM.config = SMODS.current_mod.config

MaxBoiSM.SMODSref = SMODS.current_mod

MaxBoiSM.SMODSref.reset_game_globals = function(run_start)
  if (run_start) then
    G.GAME.backsticker = {}
  end
end

function MaxBoiSM.get_active_backstickers()
    local ret = {}
    if G.GAME.backsticker then
        for _, v in ipairs(MaxBoiSM.Backsticker.obj_buffer) do
            if G.GAME.backsticker[v] then
                table.insert(ret, v)
            end
        end
    end
    return ret
end

function MaxBoiSM.recursiveMerge(boxes)
    local returnTable = {}
    for i,v in ipairs(boxes) do
        if v[2] and v[2].extra and type(v[2].extra) == 'table' and v[2].extra.maxboism_multi_boxes then
            local morejokers = MaxBoiSM.recursiveMerge(v[2].extra.maxboism_multi_boxes)
            for ii,vv in ipairs(morejokers) do
                table.insert(returnTable, vv)
            end
        else
            table.insert(returnTable, v)
        end
    end
    return returnTable
end

MaxBoiSM.SMODSref.calculate = function(self, context)
end

MaxBoiSM.fusionTable = {
    {{"j_photograph", "j_hanging_chad"}, "j_maxboism_photochad"},
    {{"j_greedy_joker", "j_lusty_joker", "j_wrathful_joker", "j_gluttenous_joker"}, "j_maxboism_photochad"},
    {{"j_scary_face", "j_smiley"}, "j_maxboism_slimeyface"}
}


-- lingo 2 glyphs

MaxBoiSM.SMODSref.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 4, align = "tm", padding = 0.2, colour = G.C.BLACK}, nodes = {
            {n=G.UIT.R, config = {align = 'cm'}, nodes={
    
            }},
            {n=G.UIT.R, config={minh=0.1}},
            {n=G.UIT.R, config = {minh = 0.04, minw = 4.5, colour = G.C.L_BLACK}},
            {n=G.UIT.R, nodes = {
                {n=G.UIT.C, config={minw = 3, padding=0.2}, nodes={
                    create_toggle({label = localize('maxboism_showdesc'), ref_table = MaxBoiSM.SMODSref.config, ref_value = 'showmergedesc', info = localize('maxboism_showdesc_desc'), active_colour = G.C.RED, right = true}),
                    create_toggle({label = localize('maxboism_fusionrecipes'), ref_table = MaxBoiSM.SMODSref.config, ref_value = 'fusionrecipes', info = localize('maxboism_fusionrecipes_desc'), active_colour = G.C.RED, right = true}),
                }},
                {n=G.UIT.C, config={minw = 3, padding=0.1}, nodes={
                    {n=G.UIT.R, config={minh=0.1}},
                    create_option_cycle({label = localize('maxboism_mergerenderlimit'), current_option = MaxBoiSM.SMODSref.config.mergerenderlimit, options = localize('maxboism_mergerenderlimit_info'), ref_table = MaxBoiSM.SMODSref.config, ref_value = 'mergerenderlimit', info = localize('maxboism_mergerenderlimit_desc'), colour = G.C.RED, w = 3.7*0.65/(5/6), h=0.8*0.65/(5/6), text_scale=0.5*0.65/(5/6), scale=5/6, no_pips = true}),
                }}
            }},
            
    }}
end



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

SMODS.current_mod.optional_features = {
    retrigger_joker = false,
    post_trigger = false,
    quantum_enhancements = true,
    cardareas = {
        discard = false,
        deck = false
    }
}

-------------------------
---JANKY SMODS HOOKS
-------------------------

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
        SMODS.Enhancement.super.register(self) --only actual difference is the removal of a line here
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

-- hooks rarity polling for direct modification of joker rarity polling
local poll_rarity_old = SMODS.poll_rarity
function SMODS.poll_rarity(_pool_key, _rand_key)
    if G.STATE ~= G.STATES.SHOP then
        return poll_rarity_old(_pool_key, _rand_key)
    end
    local weight_exponent = G.GAME.maxboism_sowilomod or 1
    
    local rarity_poll = pseudorandom(pseudoseed(_rand_key or ('rarity'..G.GAME.round_resets.ante))) -- Generate the poll value
    local available_rarities = copy_table(SMODS.ObjectTypes[_pool_key].rarities) -- Table containing a list of rarities and their rates
    local vanilla_rarities = {["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3, ["Legendary"] = 4}

    -- Calculate total rates of rarities
    local total_weight = 0
    for _, v in ipairs(available_rarities) do
        v.mod = G.GAME[tostring(v.key):lower().."_mod"] or 1
        -- Should this fully override the v.weight calcs?
        if SMODS.Rarities[v.key] and SMODS.Rarities[v.key].get_weight and type(SMODS.Rarities[v.key].get_weight) == "function" then
            v.weight = SMODS.Rarities[v.key]:get_weight(v.weight, SMODS.ObjectTypes[_pool_key])
        end
        v.weight = v.weight * v.mod
        -- Apply a power function to mod rarities
        v.weight = v.weight ^ weight_exponent
        total_weight = total_weight + v.weight
    end
    -- recalculate rarities to account for v.mod
    for _, v in ipairs(available_rarities) do
        v.weight = v.weight / total_weight
    end

    -- Calculate selected rarity
    local weight_i = 0
    for _, v in ipairs(available_rarities) do
        weight_i = weight_i + v.weight
        if rarity_poll < weight_i then
            if vanilla_rarities[v.key] then
                return vanilla_rarities[v.key]
            else
                return v.key
            end
        end
    end
    return nil
end

loc_colour()
G.ARGS.LOC_COLOURS.maxboism_thesky = HEX("8b0307")

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

local function load_stickers_folder()
    local mod_path = SMODS.current_mod.path
    local stickers_path = mod_path .. "/stickers"
    local files = NFS.getDirectoryItemsInfo(stickers_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("stickers/" .. file_name))()
        end
    end
end

local function load_misc_folder()
    local mod_path = SMODS.current_mod.path
    local consumables_path = mod_path .. "/misc"
    local files = NFS.getDirectoryItemsInfo(consumables_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("misc/" .. file_name))()
        end
    end
end

local function load_boosters_folder()
    local mod_path = SMODS.current_mod.path
    local boosters_path = mod_path .. "/boosters"
    local files = NFS.getDirectoryItemsInfo(boosters_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("boosters/" .. file_name))()
        end
    end
end

local function load_backstickers_folder()
    local mod_path = SMODS.current_mod.path
    local backstickers_path = mod_path .. "/backstickers"
    local files = NFS.getDirectoryItemsInfo(backstickers_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("backstickers/" .. file_name))()
        end
    end
end

local function load_decks_folder()
    local mod_path = SMODS.current_mod.path
    local decks_path = mod_path .. "/decks"
    local files = NFS.getDirectoryItemsInfo(decks_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("decks/" .. file_name))()
        end
    end
end

local function load_blinds_folder()
    local mod_path = SMODS.current_mod.path
    local blinds_path = mod_path .. "/blinds"
    local files = NFS.getDirectoryItemsInfo(blinds_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("blinds/" .. file_name))()
        end
    end
end

local function load_rarities_file()
    local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("rarities.lua"))()
end

load_rarities_file()
load_jokers_folder()
load_consumables_folder()
load_enhancements_folder()
load_editions_folder()
load_seals_folder()
load_misc_folder()
load_stickers_folder()
load_boosters_folder()
load_backstickers_folder()
load_decks_folder()
load_blinds_folder()
