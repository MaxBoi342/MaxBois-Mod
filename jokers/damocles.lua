SMODS.Joker {
    key = "damocles",
    config = {
        extra = {
            shopmult = 2,
            numerator = 1,
            denominator = 100
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator,
            card.ability.extra.denominator,
            'j_maxboism_damocles')
        return { vars = { new_numerator, new_denominator } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            if SMODS.pseudorandom_probability(card, 'maxboism_greed', card.ability.extra.numerator, card.ability.extra.denominator, 'j_maxboism_damocles') then
                return {
                    func = function()
                        G.STATE = G.STATES.GAME_OVER
                        if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
                            G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                        end
                        G:save_settings()
                        G.FILE_HANDLER.force = true
                        G.STATE_COMPLETE = false
                    end
                }
            end
        end

        if context.end_of_round and context.cardarea == G.jokers and not (G.GAME.current_round.hands_played <= 1) then
            return {
                func = function()
                    card.ability.extra.numerator = card.ability.extra.numerator * 2
                end,
                message = localize("maxboism_joker_damocles_increase")
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_voucher_limit(G.GAME.modifiers.extra_vouchers or 1)
        SMODS.change_booster_limit(G.GAME.modifiers.extra_boosters or 2)
        change_shop_size(G.GAME.shop.joker_max or 0)
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_voucher_limit(-G.GAME.modifiers.extra_vouchers or -1)
        SMODS.change_booster_limit(-G.GAME.modifiers.extra_boosters or -2)
        change_shop_size(-(G.GAME.shop.joker_max/2) or 0)
    end

}
