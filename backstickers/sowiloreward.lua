MaxBoiSM.Backsticker {
    key = 'sowiloreward',
    rate = 0,
    badge_colour = HEX('1b1a55'),
    default_compat = false,
    sets = {
        Default = true
    },
    atlas = 'CustomStickers',
    pos = { x = 0, y = 0 },
    set_sticker = function(self, card, val)
        card.ability[self.key] = val
    end,
    calculate = function(self, context)
        if context.end_of_round then
            G.GAME.maxboism_sowilomod = 1 / (G.GAME.backsticker[self.key]["count"] + 1)
        end
    end
}