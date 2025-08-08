SMODS.Consumable {
    key = 'page5',
    set = 'page',
    pos = { x = 4, y = 0 },
    config = { extra = {
        cards_amount = 1,
        xchips = 0.5
    } },
    loc_txt = {
        name = 'Page 5',
        text = {
            [1] = '{C:inactive}Passive:{} Apply {X:chips,C:white}X#1#{} {C:blue}Chips{} before scoring concludes',
            [2] = '{C:default}Active:{} Apply {C:dark_edition}Foil{} to all cards held in hand',
            [3] = '{C:inactive}(Overrides existing editions){}'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        return { vars = { card.ability.extra.xchips } }
    end,
    cost = 5,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.cards do
            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('card1', percent)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.cards[i]:set_edition({ foil = true }, true)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.5)
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step then
            return {
                x_chips = card.ability.extra.xchips
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    set_ability = function(self, card, initial)
        card:set_edition("e_negative", true)
    end
}
