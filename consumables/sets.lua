SMODS.ConsumableType {
    key = 'page',
    primary_colour = HEX('000000'),
    secondary_colour = HEX('000000'),
    collection_rows = { 7 },
    shop_rate = 0,
    cards = {
        ['c_maxboism_page1'] = true,
        ['c_maxboism_page2'] = true,
        ['c_maxboism_page3'] = true,
        ['c_maxboism_page4'] = true,
        ['c_maxboism_page5'] = true,
        ['c_maxboism_page6'] = true,
        ['c_maxboism_page7'] = true
    },
    loc_txt = {
        name = "Page",
        collection = "Page Cards",
    }
}

SMODS.ConsumableType {
    key = 'game',
    primary_colour = HEX('c8640f'),
    secondary_colour = HEX('8c470b'),
    collection_rows = { 5, 6 },
    shop_rate = 0.25,
    cards = {
        ['c_maxboism_lingo'] = true,
    },
    loc_txt = {
        name = "Game",
        collection = "Game Cards",
    }
}

SMODS.ConsumableType {
    key = 'rune',
    primary_colour = HEX('070f2b'),
    secondary_colour = HEX('1b1a55'),
    collection_rows = { 5, 6 },
    shop_rate = 0,
    cards = {
        
    },
    loc_txt = {
        name = "Rune",
        collection = "Rune Cards",
    }
}

-- SMODS.DrawStep {
--     key = 'card_type_shader',
--     order = 11,
--     func = function(self)
--         if (self.ability.set == 'rune') and self:should_draw_base_shader() then
--             self.children.center:draw_shader('booster', nil, self.ARGS.send_to_shader)
--         end
--     end,
--     conditions = { vortex = false, facing = 'front' },
-- }

local function load_pages()
    local consumables_path = SMODS.current_mod.path .. "/consumables"
    local pages_path = consumables_path .. "/page"
    local files = NFS.getDirectoryItemsInfo(pages_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("consumables/" .. "page/" .. file_name))()
        end
    end
end

local function load_games()
    local consumables_path = SMODS.current_mod.path .. "/consumables"
    local games_path = consumables_path .. "/game"
    local files = NFS.getDirectoryItemsInfo(games_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("consumables/" .. "game/" .. file_name))()
        end
    end
end

local function load_runes()
    local consumables_path = SMODS.current_mod.path .. "/consumables"
    local runes_path = consumables_path .. "/rune"
    local files = NFS.getDirectoryItemsInfo(runes_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("consumables/" .. "rune/" .. file_name))()
        end
    end
end

load_pages()
load_games()
load_runes()

