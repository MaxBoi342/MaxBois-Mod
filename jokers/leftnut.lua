SMODS.Joker { --Left Nut
    key = 'leftnut',
    config = {
        extra = {
            xmult = 2,
            list = {}
        }
    },
    -- loc_txt = {
    --     ['name'] = 'Left Nut',
    --     ['text'] = {
    --         [1] = 'Played {C:attention}Stone{} or {C:attention}Sand{} cards give {X:mult,C:white}X#1#{} Mult',
    --         [2] = 'if played to the left of {C:attention}Non-Stone/Sand{} cards'
    --     }
    -- },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        info_queue[#info_queue + 1] = G.P_CENTERS.m_maxboism_sand
        return { vars = { card.ability.extra.xmult } }
    end,
    pos = {
        x = 0,
        y = 1
    },
    soul_pos = {
        x = 1,
        y = 1
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for i = 1, #context.full_hand do
                if SMODS.has_enhancement(context.full_hand[i], 'm_stone') or SMODS.has_enhancement(context.full_hand[i], 'm_maxboism_sand') then
                    table.insert(card.ability.extra.list, context.full_hand[i])
                else
                    return true
                end
            end
        end
        if context.individual and context.cardarea == G.play then
            for _, v in ipairs(card.ability.extra.list) do
                if context.other_card == v then
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end
        if context.after and not context.blueprint then
            card.ability.extra.list = {}
        end
    end,

    joker_display_def = function(JokerDisplay)
        ---@type JDJokerDefinition
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
                    }
                }
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text2", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local stone_cards_on_left = {}
                local total_retriggers = 0
                if text ~= 'Unknown' then
                    for i, scoring_card in pairs(scoring_hand) do
                        if SMODS.has_enhancement(scoring_card, 'm_stone') or SMODS.has_enhancement(scoring_card, 'm_maxboism_sand') then
                            table.insert(stone_cards_on_left, scoring_card)
                        else
                            break
                        end
                    end
                end
                local stone_card = JokerDisplay.calculate_leftmost_card(stone_cards_on_left)
                for _, v in ipairs(stone_cards_on_left) do
                    total_retriggers = total_retriggers + JokerDisplay.calculate_card_triggers(v, scoring_hand)
                end

                card.joker_display_values.x_mult = stone_card and
                    (card.ability.extra.xmult ^ total_retriggers) or to_big(1)
                card.joker_display_values.localized_text = localize { type = 'name_text', set = 'Enhanced', key = 'm_stone' }
                card.joker_display_values.localized_text2 = localize { type = 'name_text', set = 'Enhanced', key = 'm_maxboism_sand' }
            end
        }
    end
}
