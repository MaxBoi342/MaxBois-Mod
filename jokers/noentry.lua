SMODS.Joker { --No Entry
    key = "noentry",
    config = {
        extra = {
            baseMult = 1,
            modifier = 0.5
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.baseMult, localize('High Card', 'poker_hands'), card.ability.extra.modifier } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local remainder = {}
            local dont = false
            for _, pcard in ipairs(G.hand.cards) do
                for _, p2card in ipairs(context.full_hand) do
                    if pcard == p2card then
                        dont = true
                    end
                end
                if dont == false then
                    table.insert(remainder, pcard)
                end
                dont = false
            end
            local remainderHand, _, _, _, _ = G.FUNCS.get_poker_hand_info(remainder)
            if remainderHand ~= 'NULL' then
                local highCard = nil
                local heldPokerHand = nil
                local multCount = 0
                for i = 1, #G.handlist do
                    if G.handlist[i] == 'High Card' then
                        highCard = i
                    end
                    if G.handlist[i] == remainderHand then
                        heldPokerHand = i
                    end
                end
                multCount = highCard - heldPokerHand
                return {
                    xmult = card.ability.extra.baseMult + (multCount * card.ability.extra.modifier),
                    message = localize(remainderHand, 'poker_hands')
                }
            end
        end
    end,
    joker_display_def = function(JokerDisplay)
        ---@type JDJokerDefinition
        return {
            text = {
                {
                    border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" },
                },
                border_colour = G.C.MULT
                }
            },
            reminder_text = {
                { ref_table = "card.joker_display_values", ref_value = "localized_hand", colour = G.C.ORANGE },
            },
            calc_function = function(card)
                local text, _, _ = JokerDisplay.evaluate_hand()
                local multCount = 0
                local remainderHand
                if text ~= 'Unknown' then
                    local remainder = {}
                    local dont = false
                    for _, pcard in ipairs(G.hand.cards) do
                        for _, p2card in ipairs(JokerDisplay.current_hand) do
                            if pcard == p2card then
                                dont = true
                            end
                        end
                        if dont == false then
                            table.insert(remainder, pcard)
                        end
                        dont = false
                    end
                    remainderHand, _, _, _, _ = G.FUNCS.get_poker_hand_info(remainder)
                    if remainderHand ~= 'NULL' then
                        local highCard = nil
                        local heldPokerHand = nil
                        local multCount = 0
                        for i = 1, #G.handlist do
                            if G.handlist[i] == 'High Card' then
                                highCard = i
                            end
                            if G.handlist[i] == remainderHand then
                                heldPokerHand = i
                            end
                        end
                        multCount = highCard - heldPokerHand
                    end
                end

                card.joker_display_values.xmult = (card.ability.extra.baseMult + (multCount * card.ability.extra.modifier)) or 1

                if remainderHand then
                    card.joker_display_values.localized_hand = localize(remainderHand, 'poker_hands')
                else
                    card.joker_display_values.localized_hand = 'None'
                end
            end,
        }
    end
}
