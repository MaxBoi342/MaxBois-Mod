SMODS.Consumable {
    key = 'naudiz',
    set = 'rune',
    pos = { x = 1, y = 1 },
    config = { extra = {
        counter = 0,
    } },
    cost = 10,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    can_use = function(self, card)
        return card.ability.extra.counter >= 3
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'maxboism_naudizshield', set = 'Other' }
        return { vars = { card.ability.extra.counter } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.consumeables then
            return {
                func = function()
                    card.ability.extra.counter = card.ability.extra.counter + 1
                end
            }
        end
    end,
    use = function(self, card, area, copier)
        MaxBoiSM.Backstickers['maxboism_naudizshield']:apply(true)
    end,
}