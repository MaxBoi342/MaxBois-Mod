SMODS.Atlas({
    key = "DamoclesString",
    path = "DamoclesString.png",
    px = 71,
    py = 1900,
    atlas_table = "ASSET_ATLAS"
}):register()

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
    end,
    set_sprites = function(self, card, front)
        if self.discovered or card.bypass_discovery_center then
            card.children['maxboism_damocles_string'] = Sprite(card.T.x, card.T.y, card.T.w, card.T.h,
                G.ASSET_ATLAS["maxboism_DamoclesString"], {
                    x = 0,
                    y = 0,
                })
            card.children['maxboism_damocles_string'].role.draw_major = card
            card.children['maxboism_damocles_string'].states.hover.can = false
            card.children['maxboism_damocles_string'].states.click.can = false
        end
    end,

}

SMODS.DrawStep {
    key = 'damoclesstring',
    order = -15,
    func = function(card, layer)
        if card.config.center_key == 'j_maxboism_damocles' then
            if card.children.maxboism_damocles_string then

                local string_pos = { (card.VT.x + (card.VT.w / 2) + G.ROOM.T.x), (card.VT.y + G.ROOM.T.y + (card.VT.h * 20)) }
                
                card.children.maxboism_damocles_string:draw_shader('dissolve', nil, nil, true, card.children.center, nil, nil, nil, -card.VT.h * 19.5,
                    nil, nil)
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys.maxboism_damocles_string = true


