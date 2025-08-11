SMODS.Joker { --VS MaxBoi
    key = "vsmaxboi",
    config = {
        extra = {
            odds = 10,
            emult = 1.5
        }
    },
    -- loc_txt = {
    --     ['name'] = 'VS MaxBoi',
    --     ['text'] = {
    --         [1] = '{C:green}#1# in #2#{} chance to give {X:red,C:white}^1.5{} mult.'
    --     }
    -- },
    pos = {
        x = 8,
        y = 0
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
            'j_maxboism_vsmaxboi')
        return { vars = { new_numerator, new_denominator } }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            if true then
                if SMODS.pseudorandom_probability(card, 'group_0_3d6b4cdb', 1, card.ability.extra.odds, 'j_maxboism_vsmaxboi') then
                    SMODS.calculate_effect({ e_mult = card.ability.extra.emult }, card)
                end
            end
        end
    end
}
