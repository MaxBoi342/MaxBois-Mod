SMODS.Joker { --Pickled Mask
    key = "goldeneagle",
    config = {
        extra = {
        }
    },
    -- loc_vars = function(self, info_queue, card)
    --     info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
    -- end,
    -- loc_txt = {
    --     ['name'] = 'Pickled Mask',
    --     ['text'] = {
    --         [1] = 'All played {C:attention}face{} cards',
    --         [2] = 'become {C:dark_edition}Polychrome{} cards when scored'
    --     }
    -- },
    pos = {
        x = 4,
        y = 1
    },
    cost = 20,
    rarity = "maxboism_friendendary",
    pools = {
        ['maxboism_zaza'] = true
    },
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 5,
        y = 1
    },

    calculate = function(self, card, context)
    end
}