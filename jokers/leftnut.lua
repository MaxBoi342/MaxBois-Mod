SMODS.Joker { --Left Nut
    key = 'leftnut',
    config = {
        extra = {
            xmult = 2,
            list = {},
            repetitions = 2,
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
            card.ability.extra.list = {}
        end
        if context.repetition and context.cardarea == G.play then
            for _, v in ipairs(card.ability.extra.list) do
                if context.other_card == v then
                    if SMODS.has_enhancement(v, 'm_stone') and SMODS.has_enhancement(v, 'm_maxboism_sand') then
                        return {
                            repetitions = card.ability.extra.repetitions * 2
                        }
                    else
                        return {
                            repetitions = card.ability.extra.repetitions
                        }
                    end
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
                { ref_table = "card.joker_display_values", ref_value = "localized_response", colour = G.C.GREY },
            },
            reminder_text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text",  colour = G.C.ORANGE },
                { text = "/" },
                { ref_table = "card.joker_display_values", ref_value = "localized_text2", colour = G.C.ORANGE },
                { text = ")" },
            },
            calc_function = function(card)
                local text, _, _ = JokerDisplay.evaluate_hand()
                local response = ''
                local endLeft = true
                if text ~= 'Unknown' then
                    for _, v in ipairs(JokerDisplay.current_hand) do
                    if (SMODS.has_enhancement(v, 'm_stone') or SMODS.has_enhancement(v, 'm_maxboism_sand')) and endLeft then
                        if SMODS.has_enhancement(v, 'm_stone') and SMODS.has_enhancement(v, 'm_maxboism_sand') then
                            response = response .. ' (B) '
                        else
                            response = response .. ' (O) '
                        end
                    else
                    endLeft = false
                        response = response .. ' (X) '
                    end
                end
                end
                

                card.joker_display_values.localized_response = response
                card.joker_display_values.localized_text = localize { type = 'name_text', set = 'Enhanced', key = 'm_stone' }
                card.joker_display_values.localized_text2 = localize { type = 'name_text', set = 'Enhanced', key = 'm_maxboism_sand' }
            end
        }
    end
}
