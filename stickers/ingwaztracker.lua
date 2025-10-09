SMODS.Sticker {
    key = 'ingwaztracker',
    rate = 0,
    ignore_debuff = true,
    badge_colour = HEX('1b1a55'),
    default_compat = false,
    sets = {
        Joker = true
    },
    atlas = 'CustomStickers',
    pos = { x = 2, y = 0 },
    set_sticker = function(self, card, val)
        card.ability[self.key] = val
    end,
    calculate = function(self, card, context)
        if context.ante_change and context.ante_end then
            local jokers = {}
            if card.ability.maxboism_ingwazorder == 1 then
                for i,v in ipairs(G.jokers.cards) do
                    if v.ability.maxboism_ingwazid == card.ability.maxboism_ingwazid then
                        SMODS.debuff_card(v, false, "ingwaz")
                        SMODS.recalc_debuff(v)
                        table.insert(jokers, v)
                        v:add_sticker("maxboism_ingwaztracker", false)
                    end
                end
                table.sort(jokers, function(a,b)
                    return a.ability.maxboism_ingwazorder < b.ability.maxboism_ingwazorder
                end)
                return {
                    func = function()
                        MaxBoiSM.merge(jokers)
                    end
                }
            end
        end
    end,
}