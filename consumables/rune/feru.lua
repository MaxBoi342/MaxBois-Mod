SMODS.Consumable {
    key = 'feru',
    set = 'rune',
    pos = { x = 0, y = 1 },
    config = { extra = {
        counter = 0
    } },
    cost = 10,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    can_use = function(self, card)
        if card.ability.extra.counter >= 5 then
            return true
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.counter } }
    end,
    calculate = function(self, card, context)
        if context.money_altered and not context.from_shop then
            if to_big(context.amount) > to_big(0) then
                    return {
                        dollars = -to_number(context.amount),
                        message = 'Blocked!',
                        colour = G.C.RED,
                        remove_default_message = true
                    }
            end
        end
        if context.end_of_round and context.cardarea == G.consumeables then
            return {
                func = function()
                    card.ability.extra.counter = card.ability.extra.counter + 1
                end
            }
        end
        if context.setting_blind and (card.ability.extra.counter or 0) >= 5 then
                local function juice_card_until_(card, eval_func, first, delay) -- balatro function doesn't allow for custom scale and rotation
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = delay or 0.1,
                        blocking = false,
                        blockable = false,
                        timer = 'REAL',
                        func = (function()
                            if eval_func(card) then
                                if not first or first then
                                    card:juice_up(card.ability.extra.scale,
                                        card.ability.extra.rotation)
                                end; juice_card_until_(card, eval_func, nil, 0.8)
                            end
                            return true
                        end)
                    }))
                end
                return {
                    func = function()
                        local eval = function() return not G.RESET_JIGGLES end
                        juice_card_until_(card, eval, true)
                        return true
                    end
                }
            end
        
    end,
    use = function(self, card, area, copier)
        MaxBoiSM.Backstickers['maxboism_ferureward']:apply(true)
    end,
    

}
