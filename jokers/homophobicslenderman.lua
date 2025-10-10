SMODS.Joker { --Homophobic Slenderman
    key = "homophobicslenderman",
    config = {
        extra = {
            echips = 7,
            emult = 7,
            costIncrease = 5,
            rate = 2
        }
    },
    -- loc_txt = {
    --     ['name'] = 'Homophobic Slenderman',
    --     ['text'] = {
    --         [1] = 'Collect my {C:attention}Page{} cards from the {C:attention}shop{}',
    --         [2] = '{C:inactive}(Currently #1#/7){}'
    --     }
    -- },
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
            --     if context.using_consumeable then
            --         if context.consumeable and (context.consumeable.ability.set == 'page' or context.consumeable.ability.set == 'page') then
            --             return {
            --                 func = function()
            --                     card.ability.extra.heldPages = math.max(0, (card.ability.extra.heldPages) - 1)
            --                     return true
            --                 end,
            --                 message = localize("maxboism_joker_homophobicslenderman_lost")
            --             }
            --         end
            --     end
            --     if context.selling_card and (context.card.config.center.set == 'page' or context.card.config.center.set == 'page') then --modify existing sell rules
            --         return {
            --             func = function()
            --                 card.ability.extra.heldPages = math.max(0, (card.ability.extra.heldPages) - 1)
            --                 return true
            --             end,
            --             message = localize("maxboism_joker_homophobicslenderman_lost")
            --         }
            --     end
            -- if context.buying_card or context.using_consumable or context.selling_card then --fix when selling it actually go down mfer
            --     local newCount = 0
            --     for _, v in ipairs(G.consumeables.cards) do
            --         if v.ability.set == 'page' then
            --             newCount = newCount + 1
            --         end
            --     end

            --     if (context.selling_card and context.card.config.center.set == 'page') or (context.using_consumeable and context.consumeable.ability.set == 'page') then
            --         newCount = newCount - 1
            --     end

            --     if newCount > card.ability.extra.heldPages then
            --         return {
            --             func = function()
            --                 card.ability.extra.heldPages = math.max(0, newCount)
            --                 return true
            --             end,
            --             message = localize("maxboism_joker_homophobicslenderman_found")
            --         }
            --     elseif newCount < card.ability.extra.heldPages then
            --         return {
            --             func = function()
            --                 card.ability.extra.heldPages = math.max(0, newCount)
            --                 return true
            --             end,
            --             message = localize("maxboism_joker_homophobicslenderman_lost")
            --         }
            --     else
            --         return {
            --             func = function()
            --                 card.ability.extra.heldPages = math.max(0, newCount)
            --                 return true
            --             end,
            --         }
            --     end
            -- end
            if context.cardarea == G.jokers and context.joker_main then
                if (G.GAME.maxboism_pagecount or 0) >= 7 then
                    return {
                        e_chips = card.ability.extra.echips,
                        extra = {
                            e_mult = card.ability.extra.emult,
                            colour = G.C.DARK_EDITION
                        }
                    }
                else
                    return {
                        xchips = math.max(1, (G.GAME.maxboism_pagecount or 0)),
                        xmult = math.max(1, (G.GAME.maxboism_pagecount or 0)),
                    }
                end
            end
            if context.setting_blind and (G.GAME.maxboism_pagecount or 0) >= 7 then
                local function juice_card_until_(card, eval_func, first, delay) -- balatro function doesn't allow for custom scale and rotation
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = delay or 0.1,
                        blocking = false,
                        blockable = false,
                        timer = 'REAL',
                        func = (function()
                            if eval_func(card) then
                                if not first or first then
                                    card:juice_up(card.ability.extra.scale,
                                        card.ability.extra.rotation)
                                end; juice_card_until_(card, eval_func, nil, 0.8)
                            end
                            return true
                        end)
                    }))
                end
                return {
                    func = function()
                        local eval = function() return not G.RESET_JIGGLES end
                        juice_card_until_(card, eval, true)
                        return true
                    end
                }
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.page_rate = card.ability.extra.rate and card.ability.extra.rate or G.GAME.page_rate and G.GAME.page_rate or 0
                local created_consumable = false
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    created_consumable = true
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card { set = 'page', key = nil, key_append = 'joker_forge_page' }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                end
                if created_consumable then
                    card_eval_status_text(card, 'extra', nil, nil, nil,
                        { message = localize("maxboism_joker_homophobicslenderman_freebie"), colour = G.C.PURPLE })
                end
                return true
            end
        }))
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.page_rate = 0
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
