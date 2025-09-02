SMODS.Sticker {
    key = 'algiztracker',
    rate = 0,
    badge_colour = HEX('1b1a55'),
    default_compat = false,
    sets = {
        Joker = true
    },
    atlas = 'CustomStickers',
    pos = { x = 0, y = 0 },
    set_sticker = function(self, card, val)
        card.ability[self.key] = val
        for _,v in ipairs(G.jokers.cards) do
                if v.ability[self.key] then
                    SMODS.debuff_card(v, true, 'algiz')
                end
            end
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            for _,v in ipairs(G.jokers.cards) do
                if v.ability[self.key] then
                    SMODS.debuff_card(v, true, 'algiz')
                end
            end
        end
    end
}