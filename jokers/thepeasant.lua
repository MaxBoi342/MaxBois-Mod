SMODS.Joker { --The Peasant
    key = "thepeasant",
    config = {
        extra = {
            mult = 1.1
        }
    },
    loc_txt = {
        ['name'] = 'The Peasant',
        ['text'] = {
            [1] = 'Score {X:mult,C:white}X#1# {} when a {C:orange}face{} card is scored,',
            [2] = 'then increase Mult by {X:mult,C:white}X0.1{}',
            [3] = '(Mult resets after hand)'
        }
    },
    pos = {
        x = 7,
        y = 0
    },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_face() then
                local mult_value = card.ability.extra.mult
                card.ability.extra.mult = (card.ability.extra.mult) * 1.1
                return {
                    Xmult = mult_value
                }
            end
        end
        if context.after and context.cardarea == G.jokers then
            return {
                func = function()
                    card.ability.extra.mult = 1.1
                    return true
                end,
                message = "Reset!"
            }
        end
    end
}
