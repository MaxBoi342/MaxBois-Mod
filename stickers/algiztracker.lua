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
        for _, v in ipairs(G.jokers.cards) do
            if v.ability[self.key] then
                SMODS.debuff_card(v, true, 'algiz')
            end
        end
    end,
    calculate = function(self, card, context)
        -- if G.STATE == G.STATES.SELECTING_HAND then
        --     for _, v in ipairs(G.jokers.cards) do
        --         if v.ability[self.key] and not v.config.maxboism_algizblind then
        --             SMODS.debuff_card(v, true, 'algiz')
        --             G.GAME.blind.chips = G.GAME.blind.chips * 2
        --             G.GAME.blind.chip_text = tostring(G.GAME.blind.chips)
        --             SMODS.juice_up_blind()
        --             v.config.maxboism_algizblind = true
        --         end
        --     end
        -- end
        -- if context.ending_shop then
        --     for _, v in ipairs(G.jokers.cards) do
        --         if v.ability['maxboism_algiztracker'] then
        --             v.config.maxboism_algizblind = false
        --         end
        --     end
        -- end
        -- if context.end_of_round and SMODS.last_hand_oneshot then
        --     for _, v in ipairs(G.jokers.cards) do
        --         if v.ability['maxboism_algiztracker'] then
        --             SMODS.debuff_card(v, false, 'algiz')
        --             SMODS.recalc_debuff(v)
        --             SMODS.Stickers['maxboism_algiztracker']:apply(v, false)
        --             v:juice_up()
        --         end
        --     end
        -- end
    end
}
