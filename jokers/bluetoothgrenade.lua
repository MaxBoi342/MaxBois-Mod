SMODS.Sound {
    key = "throwinggrenade",
    path = "throwinggrenade.ogg"
}

SMODS.Sound {
    key = "grenade",
    path = "grenade.ogg"
}

SMODS.Joker { --Bluetooth Grenade
    key = "bluetoothgrenade",
    config = {
        extra = {
            timer = 0,
            dollars = 50,
            scale = 3,
            rotation = 1,
            constant = 0
        }
    },
    loc_txt = {
        ['name'] = 'Bluetooth Grenade',
        ['text'] = {
            [1] = 'After {C:attention}5{} rounds, this card {C:attention}explodes{} and gives {C:money}$50{}',
            [2] = '{C:inactive}(Currently {C:attention}#1#{}/5){}'
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.timer } }
    end,

    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if context.end_of_round and context.game_over == false and context.main_eval then
                if (card.ability.extra.timer or 0) >= 5 then
                    return {
                        dollars = card.ability.extra.dollars,
                        extra = {
                            func = function()
                                card:start_dissolve()
                                return true
                            end,
                            message = "Destroyed!",
                            colour = G.C.RED
                        }
                    }
                end
            end
            if context.buying_card and context.card.config.center.key == self.key and context.cardarea == G.jokers then
                play_sound("maxboism_throwinggrenade")
                return {
                    message = "Throwing!"
                }
            end
            if context.setting_blind then
                if (card.ability.extra.timer or 0) >= 4 then
                    play_sound("maxboism_grenade")
                    local target_card = context.other_card
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
                        end,
                        extra = {
                            func = function()
                                card.ability.extra.timer = (card.ability.extra.timer) + 1
                                return true
                            end,
                            colour = G.C.GREEN
                        }
                    }
                else
                    return {
                        func = function()
                            card.ability.extra.timer = (card.ability.extra.timer) + 1
                            return true
                        end
                    }
                end
            end
        end
    end
}
