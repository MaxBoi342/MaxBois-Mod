SMODS.Joker { --Homophobic Slenderman
    key = "homophobicslenderman",
    config = {
        extra = {
            hand_change = 0,
            heldPages = 0,
            echips = 7,
            emult = 7,
            page = 0,
            rate = 4
        }
    },
    loc_txt = {
        ['name'] = 'Homophobic Slenderman',
        ['text'] = {
            [1] = 'Collect my {C:attention}Page{} cards from the {C:attention}shop{}',
            [2] = '{C:inactive}(Currently #1#/7){}'
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
        return { vars = { card.ability.extra.heldPages } }
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if context.buying_card and context.card.config.center.key == self.key and context.cardarea == G.jokers then
                return {
                    func = function()
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
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                                { message = "Freebie!", colour = G.C.PURPLE })
                        end
                        return true
                    end,
                    extra = {
                        func = function()
                            card.ability.extra.heldPages = (card.ability.extra.heldPages) + 1
                            return true
                        end,
                        message = "Found!",
                        colour = G.C.GREEN
                    }
                }
            end
            if context.buying_card then
                if context.card and (context.card.ability.set == 'page' or context.card.ability.set == 'page') then
                    return {
                        func = function()
                            card.ability.extra.heldPages = (card.ability.extra.heldPages) + 1
                            return true
                        end,
                        message = "Found!"
                    }
                end
            end
            if context.using_consumeable then
                if context.consumeable and (context.consumeable.ability.set == 'page' or context.consumeable.ability.set == 'page') then
                    return {
                        func = function()
                            card.ability.extra.heldPages = math.max(0, (card.ability.extra.heldPages) - 1)
                            return true
                        end,
                        message = "Lost..."
                    }
                end
            end
            if context.selling_card and (context.card.config.center.set == 'page' or context.card.config.center.set == 'page') then --modify existing sell rules
                return {
                    func = function()
                        card.ability.extra.heldPages = math.max(0, (card.ability.extra.heldPages) - 1)
                        return true
                    end,
                    message = "Lost..."
                }
            end
            if context.cardarea == G.jokers and context.joker_main then
                if (card.ability.extra.heldPages or 0) >= 7 then
                    return {
                        e_chips = card.ability.extra.echips,
                        extra = {
                            e_mult = card.ability.extra.emult,
                            colour = G.C.DARK_EDITION
                        }
                    }
                end
            end
            if context.setting_blind and (card.ability.extra.heldPages or 0) >= 7 then
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
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hand_change
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.page_rate = card.ability.extra.rate
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
    end
}
