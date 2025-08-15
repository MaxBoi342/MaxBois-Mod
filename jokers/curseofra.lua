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

SMODS.Joker:take_ownership('j_stone',
    {
        loc_vars = function(self, info_queue, card)
            return {
                vars = { 25, ((function()
                    local count = 0;
                    for _, card in ipairs(G.playing_cards or {}) do
                        if next(SMODS.find_card('j_maxboism_curseofra')) then
                            if SMODS.has_enhancement(card, 'm_stone') or SMODS.has_enhancement(card, 'm_maxboism_sand') then
                                count = count + 1
                            end
                        else
                            if SMODS.has_enhancement(card, 'm_stone') then
                                count = count + 1
                            end
                        end
                    end;
                    return count
                end)()
                ) * 25 }
            }
        end,

        calculate = function(self, card, context)
            if context.cardarea == G.jokers and context.joker_main then
                return {
                    chips = ((function()
                        local count = 0;
                        for _, card in ipairs(G.playing_cards or {}) do
                            if next(SMODS.find_card('j_maxboism_curseofra')) then
                                if SMODS.has_enhancement(card, 'm_stone') or SMODS.has_enhancement(card, 'm_maxboism_sand') then
                                    count = count + 1
                                end
                            else
                                if SMODS.has_enhancement(card, 'm_stone') then
                                    count = count + 1
                                end
                            end
                        end;
                        return count
                    end)()
                    ) * 25
                }
            end
        end,
    }, true)
