SMODS.Joker { --No Entry
    key = "ghostbuster",
    config = {
        extra = {
            xmult = 1,
            base = 1,
            increment = 0.1
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    loc_vars = function(self, info_queue, card)
        return {vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.using_consumeable then
            if context.consumeable.ability.set and context.consumeable.ability.set == 'Spectral' then
                
                card.ability.extra.xmult = card.ability.extra.base + card.ability.extra.increment *
                        ((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral and G.GAME.consumeable_usage_total.spectral > 0 and G.GAME.consumeable_usage_total.spectral) or 0)
                return {
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil,
                            { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } } })
                        return true
                    end
                }
            end
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.xmult = card.ability.extra.base + card.ability.extra.increment *
                        ((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral and G.GAME.consumeable_usage_total.spectral > 0 and G.GAME.consumeable_usage_total.spectral) or 0)
    end,
    joker_display_def = function(JokerDisplay)
        ---@type JDJokerDefinition
        return {
            text = {
                {
                    border_nodes = {
                        { text = "X" },
                        { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" },
                    },
                    border_colour = G.C.MULT,
                }
            },
        }
    end
}
