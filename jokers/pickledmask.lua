SMODS.Joker { --Pickled Mask
    key = "pickledmask",
    config = {
        extra = {
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
    end,
    -- loc_txt = {
    --     ['name'] = 'Pickled Mask',
    --     ['text'] = {
    --         [1] = 'All played {C:attention}face{} cards',
    --         [2] = 'become {C:dark_edition}Polychrome{} cards when scored'
    --     }
    -- },
    pos = {
        x = 4,
        y = 0
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 5,
        y = 0
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_face() then
                context.other_card:set_edition("e_polychrome", true)
                return {
                    message = localize("maxboism_joker_pickledmask_message")
                }
            end
        end
    end
}
