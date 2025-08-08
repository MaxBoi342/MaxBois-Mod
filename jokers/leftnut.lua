SMODS.Joker { --Left Nut
    key = 'leftnut',
    config = {
        extra = {
            xmult = 2,
            nonStonePlayed = 0
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
        if context.before then
            for i = 1, #context.scoring_hand do
                if not SMODS.has_enhancement(context.scoring_hand[i], 'm_stone') and not SMODS.has_enhancement(context.scoring_hand[i], 'm_maxboism_sand') then 
                    card.ability.extra.nonStonePlayed = i
                    return true
                end
            end
        end
        if context.individual and context.cardarea == G.play then
            if SMODS.has_enhancement(context.other_card, 'm_stone') or SMODS.has_enhancement(context.other_card, 'm_maxboism_sand') then 
                if card.ability.extra.nonStonePlayed > 1 then
                    card.ability.extra.nonStonePlayed  = card.ability.extra.nonStonePlayed - 1
                    return {
                        xmult = card.ability.extra.xmult
                    }
                else
                end
            else
            end
        end
    end
}
