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
        info_queue[#info_queue + 1] = { key = 'maxboism_ferureward', set = 'Other' }
        return { vars = { card.ability.extra.counter } }
    end,
    select_card = "consumeables",
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
    end,
    use = function(self, card, area, copier)
        MaxBoiSM.Backstickers['maxboism_ferureward']:apply(true)
    end,
    

}
