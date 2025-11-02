MaxBoiSM.Backsticker {
    key = 'ferureward',
    rate = 0,
    badge_colour = HEX('1b1a55'),
    default_compat = false,
    sets = {
        Default = true
    },
    config = {
        count = 1
    },
    atlas = 'CustomBackstickers',
    pos = { x = 0, y = 0 },
    set_sticker = function(self, card, val)
        card.ability[self.key] = val
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {2, 2}}
    end,
    calculate = function(self, context)
        if not MaxBoiSM.DISABLE_MONEY_REPEATS then
            if context.money_altered and to_big(context.amount) > to_big(0) then
                MaxBoiSM.DISABLE_MONEY_REPEATS = true
                return {
                    dollars = to_number(context.amount) * G.GAME.backsticker[self.key].count,
                    func = function()
                        MaxBoiSM.DISABLE_MONEY_REPEATS = false
                    end
                }
            end
        end
    end
}