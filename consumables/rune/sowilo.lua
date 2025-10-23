SMODS.Consumable {
    key = 'sowilo',
    set = 'rune',
    pos = { x = 1, y = 1 },
    config = { extra = {

    } },
    cost = 10,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    can_use = function(self, card)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        
    end,
    calculate = function(self, card, context)

    end,
    use = function(self, card, area, copier)
        MaxBoiSM.Backstickers['maxboism_sowiloreward']:apply(true)
    end,
}