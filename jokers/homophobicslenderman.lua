SMODS.Joker { --Homophobic Slenderman
    key = "homophobicslenderman",
    config = {
        extra = {
            costIncrease = 5,
            rate = 2
        }
    },
    pos = {
        x = 3,
        y = 0
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.maxboism_pagecount and G.GAME.maxboism_pagecount > 0 and G.GAME.maxboism_pagecount or 0, math.max(1, G.GAME.maxboism_pagecount and G.GAME.maxboism_pagecount > 0 and G.GAME.maxboism_pagecount or 0) } }
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if context.buying_card then
                if context.card and (context.card.ability.set == 'page' or context.card.ability.set == 'page') then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if not G.GAME.homophobic_inflation then
                                G.GAME.homophobic_inflation = card.ability.extra.costIncrease
                            else
                                G.GAME.homophobic_inflation = G.GAME.homophobic_inflation +
                                card.ability.extra.costIncrease
                            end
                            for _, v in ipairs(G.I.CARD) do
                                if v.set_cost then v:set_cost() end
                            end
                            return true
                        end
                    }))
                end
            end
            if context.cardarea == G.jokers and context.joker_main then
                    return {
                        xchips = math.max(1, (G.GAME.maxboism_pagecount or 0)),
                        xmult = math.max(1, (G.GAME.maxboism_pagecount or 0)),
                    }
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.page_rate = card.ability.extra.rate and card.ability.extra.rate or G.GAME.page_rate and G.GAME.page_rate or 2
                return true
            end
        }))
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.page_rate = G.GAME.page_rate and G.GAME.page_rate - card.ability.extra.rate >= 0 and G.GAME.page_rate - card.ability.extra.rate or 0
                return true
            end
        }))
    end,

    joker_display_def = function(JokerDisplay)
        ---@type JDJokerDefinition
        return {
            text = {
                { text = "(" },
                { ref_table = "G.GAME", ref_value = "maxboism_pagecount" },
                { text = "/7)" }

            },
            text_config = { colour = G.C.GREY }
        }
    end
}
