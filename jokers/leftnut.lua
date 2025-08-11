SMODS.Joker { --Left Nut
    key = 'leftnut',
    config = {
        extra = {
            xmult = 2,
            list = {}
        }
    },
    loc_txt = {
        ['name'] = 'Left Nut',
        ['text'] = {
            [1] = 'Played {C:attention}Stone{} or {C:attention}Sand{} cards give {X:mult,C:white}X#1#{} Mult',
            [2] = 'if played to the left of {C:attention}Non-Stone/Sand{} cards'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        info_queue[#info_queue + 1] = G.P_CENTERS.m_maxboism_sand
        return { vars = { card.ability.extra.xmult } }
    end,
    pos = {
        x = 0,
        y = 1
    },
    soul_pos = {
        x = 1,
        y = 1
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for i = 1, #context.full_hand do
                if SMODS.has_enhancement(context.full_hand[i], 'm_stone') or SMODS.has_enhancement(context.full_hand[i], 'm_maxboism_sand') then 
                    table.insert(card.ability.extra.list, context.full_hand[i])
                else
                    return true
                end
            end
        end
        if context.individual and context.cardarea == G.play then
            for _, v in ipairs(card.ability.extra.list) do
                if context.other_card == v then
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end
        if context.after and not context.blueprint then
            card.ability.extra.list = {}
        end
    end
}
