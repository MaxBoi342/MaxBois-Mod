SMODS.Consumable {
    key = 'page3',
    set = 'page',
    pos = { x = 2, y = 0 },
    config = { extra = {
        hand_size_value = 1
    } },
    -- loc_txt = {
    --     name = 'Page 3',
    --     text = {
    --         [1] = '{C:inactive}Passive:{} {C:red}-1{} hand size',
    --         [2] = '{C:default}Active:{} {C:attention}+1{} hand size'
    --     }
    -- },
    cost = 5,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                card_eval_status_text(used_card, 'extra', nil, nil, nil, { message = "Greed!", colour = G.C.BLUE })
                G.hand:change_size(1)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(-1)
        G.E_MANAGER:add_event(Event({
            func = function()
                local newCount = 0
                for _, v in ipairs(G.consumeables.cards) do
                    if v.ability.set == 'page' then
                        newCount = newCount + 1
                    end
                end
                for _, v in ipairs(SMODS.find_card('j_maxboism_homophobicslenderman', true)) do
                    v.ability.extra.heldPages = newCount
                    card_eval_status_text(v, 'extra', nil, nil, nil,
                                { message = localize("maxboism_joker_homophobicslenderman_found"), colour = G.C.GREEN })
                end
                    return true
            end
        }))
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(1)
        G.E_MANAGER:add_event(Event({
            func = function()
                local newCount = 0
                for _, v in ipairs(G.consumeables.cards) do
                    if v.ability.set == 'page' then
                        newCount = newCount + 1
                    end
                end
                for _, v in ipairs(SMODS.find_card('j_maxboism_homophobicslenderman', true)) do
                    v.ability.extra.heldPages = newCount
                    card_eval_status_text(v, 'extra', nil, nil, nil,
                                { message = localize("maxboism_joker_homophobicslenderman_lost"), colour = G.C.RED })
                end
                    return true
            end
        }))
    end,
    set_ability = function(self, card, initial)
        card:set_edition("e_negative", true)
    end,
    
}
