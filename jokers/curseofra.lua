SMODS.Joker { --Curse Of Ra
    key = "curseofra",
    config = {
        extra = {
            xchips = 1.5
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        info_queue[#info_queue + 1] = G.P_CENTERS.m_maxboism_sand
    end,
    -- loc_txt = {
    --     ['name'] = 'Curse Of Ra',
    --     ['text'] = {
    --         [1] = 'Converts {C:attention}Stone{} cards in hand to {C:attention}Sand{} cards',
    --         [2] = '{C:attention}Stone Joker{} also counts {C:attention}Sand{} cards now'
    --     }
    -- },
    pos = {
        x = 2,
        y = 0
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        -- if context.check_enhancement and context.other_card.ability.name == 'm_maxboism_sand' then
        --     return {
        --         m_maxboism_sand = true,
        --         m_stone = true,
        --     }
        -- end
        if context.hand_drawn and not context.blueprint then
            local count = 0
            for _, v in ipairs(G.hand.cards) do
                if SMODS.has_enhancement(v, 'm_stone') then
                    v:juice_up(0.8, 0.5)
                    v:set_ability('m_maxboism_sand')
                    count = count + 1
                end
            end
            if count == 0 then
                return
            else
                return {
                    message = localize("maxboism_joker_curseofra_message")
                }
            end
        end
    end,
}

local get_enhancement_old = SMODS.get_enhancements

function SMODS.get_enhancements(card, extra_only)
    local ret = get_enhancement_old(card, extra_only)

    if ret and ret.m_maxboism_sand == true and next(SMODS.find_card("j_maxboism_curseofra")) then
        ret.m_stone = true
    end
    return ret
end
