SMODS.Sticker {
    key = 'algiztracker',
    rate = 0,
    ignore_debuff = true,
    badge_colour = HEX('1b1a55'),
    default_compat = false,
    sets = {
        Joker = true
    },
    atlas = 'CustomStickers',
    pos = { x = 1, y = 0 },
    set_sticker = function(self, card, val)
        card.ability[self.key] = val
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.debuff_card(card, true, 'algiz')
                    SMODS.recalc_debuff(card)
                    return true
                end,
            }))
        elseif (G.STATE == 1 and not card.debuff) then
            SMODS.debuff_card(card, true, 'algiz')
            SMODS.recalc_debuff(card)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.blind.chips = G.GAME.blind.chips * 2
                    G.GAME.blind.chip_text = tostring(G.GAME.blind.chips)
                    SMODS.juice_up_blind()
                    return true
                end,
            }))
        end
        if context.end_of_round and SMODS.last_hand_oneshot then
            return {
                func = function()
                    SMODS.debuff_card(card, false, 'algiz')
                    SMODS.recalc_debuff(card)
                    SMODS.Stickers['maxboism_algiztracker']:apply(card, false)
                    card:juice_up()
                end
            }
        end
    end
}

local get_blind_amount_orig = get_blind_amount
function get_blind_amount(ante)
    local normal_amount = get_blind_amount_orig(ante)
    local count = 1
    if not G.jokers or not G.jokers.cards then return end
    for i,v in ipairs(G.jokers.cards) do
        if v.ability.maxboism_algiztracker then
            count = count * 2
        end
    end
    return normal_amount * count
end
