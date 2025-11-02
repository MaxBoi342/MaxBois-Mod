SMODS.Consumable {
    key = 'sowilo',
    set = 'rune',
    pos = { x = 1, y = 1 },
    config = { extra = {
            oldmod = 0,
            counter = 0
    } },
    cost = 10,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    can_use = function(self, card)
        if card.ability.extra.counter >= 3 then
            return true
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'maxboism_sowiloreward', set = 'Other' }
        return { vars = { card.ability.extra.counter } }
    end,
    select_card = "consumeables",
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
        MaxBoiSM.Backstickers['maxboism_sowiloreward']:apply(true)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.maxboism_sowilomod = card.ability.extra.oldmod or 1.0
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.oldmod = G.GAME.maxboism_sowilomod or 1.0
        G.GAME.maxboism_sowilomod = 2.0
    end
}