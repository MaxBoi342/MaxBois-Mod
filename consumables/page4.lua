SMODS.Consumable {
    key = 'page4',
    set = 'page',
    pos = { x = 3, y = 0 },
    config = {
        extra = {
            levels = 6,
            odds = 4,
            levels2 = -1,
            most = 0
        }
    },
    -- loc_txt = {
    --     name = 'Page 4',
    --     text = {
    --         [1] = '{C:inactive}Passive:{} {C:green}#1# in #2#{} chance to decrease level of played hand',
    --         [2] = '{C:default}Active:{} Level up {C:attention}most played hand{} 6 times'
    --     }
    -- },

    cost = 5,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
            'c_maxboism_page4')
        return { vars = { new_numerator, new_denominator } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            if true then
                if SMODS.pseudorandom_probability(card, 'group_0_f7403c99', 1, card.ability.extra.odds, 'c_maxboism_page4') then
                    target_hand2 = context.scoring_name
                    SMODS.calculate_effect({
                        level_up = card.ability.extra.levels2,
                        level_up_hand = target_hand2
                    }, card)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                        { message = 'Level Down!', colour = G.C.RED })
                end
            end
        end
    end,
    use = function(self, card, area, copier)
        temp_played = 0
        temp_order = math.huge
        for hand, value in pairs(G.GAME.hands) do
            if value.played > temp_played and value.visible then
                temp_played = value.played
                temp_order = value.order
                target_hand = hand
            else
                if value.played == temp_played and value.visible then
                    if value.order < temp_order then
                        temp_order = value.order
                        target_hand = hand
                    end
                end
            end
        end
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
            {
                handname = localize(target_hand, 'poker_hands'),
                chips = G.GAME.hands[target_hand].chips,
                mult = G.GAME.hands[target_hand].mult,
                level = G.GAME.hands[target_hand].level
            })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true
            end
        }))
        update_hand_text({ delay = 0 },
            { mult = (card.ability.extra.levels >= 0 and '+' or '') ..
            tostring(G.GAME.hands[target_hand].l_mult * card.ability.extra.levels), StatusText = true })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                return true
            end
        }))
        update_hand_text({ delay = 0 },
            { chips = (card.ability.extra.levels >= 0 and '+' or '') ..
            tostring(G.GAME.hands[target_hand].l_chips * card.ability.extra.levels), StatusText = true })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true
            end
        }))
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 },
            { level = (card.ability.extra.levels >= 0 and '+' or '') .. tostring(card.ability.extra.levels) })
        delay(1.3)
        level_up_hand(card, target_hand, true, card.ability.extra.levels)
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
            {
                handname = localize(target_hand, 'poker_hands'),
                chips = G.GAME.hands[target_hand].chips,
                mult = G.GAME.hands[target_hand].mult,
                level = G.GAME.hands[target_hand].level
            })
        delay(1.3)
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
            { mult = 0, chips = 0, handname = '', level = '' })

        --SMODS.smart_level_up_hand(card, target_hand, false, card.ability.extra.levels)
    end,
    can_use = function(self, card)
        return true
    end,
    set_ability = function(self, card, initial)
        card:set_edition("e_negative", true)
    end
}
