SMODS.Joker { --No Entry
    key = "ghostbuster",
    config = {
        extra = {
            dollars = 0,
            base = 1,
            increment = 3
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
        return { vars = { card.ability.extra.increment, card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                dollars = card.ability.extra.dollars
            }
        end
        if context.using_consumeable then
            if context.consumeable.ability.set and context.consumeable.ability.set == 'Spectral' and not context.blueprint then
                card.ability.extra.dollars = card.ability.extra.increment *
                    ((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral and G.GAME.consumeable_usage_total.spectral > 0 and G.GAME.consumeable_usage_total.spectral) or 0)
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MONEY
                }
            end
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.xmult = card.ability.extra.increment *
            ((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral and G.GAME.consumeable_usage_total.spectral > 0 and G.GAME.consumeable_usage_total.spectral) or 0)
    end,
    joker_display_def = function(JokerDisplay)
        ---@type JDJokerDefinition
        return {
            text = {
                { text = "+" },
                { ref_table = "card.ability.extra", ref_value = "dollars", retrigger_type = "lin" },
                { text = "$" },
            },
            text_config = { colour = G.C.MONEY },
        }
    end
}
