---@diagnostic disable: need-check-nil
SMODS.Consumable {
    key = 'page7',
    set = 'page',
    pos = { x = 6, y = 0 },
    config = { extra = {
        add_cards_count = 2
    } },
    -- loc_txt = {
    --     name = 'Page 7',
    --     text = {
    --         [1] = '{C:inactive}Passive:{} Debuff a random card {C:attention}rank{}',
    --         [2] = '{C:default}Active:{} Give {C:attention}2{} {C:dark_edition}Negative{} cards of the given {C:attention}rank{}',
    --         [3] = '{C:inactive}(Resets every hand; Currently {C:attention}#1#s{}){}'
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
            delay = 0.7,
            func = function()
                local cards = {}
                for i = 1, 2 do
                    local _rank = G.GAME.current_round.debuffRank_card.rank
                    local _suit = nil
                    local new_card_params = { set = "Base" }
                    if _rank then new_card_params.rank = _rank end
                    if _suit then new_card_params.suit = _suit end
                    cards[i] = SMODS.add_card(new_card_params)
                    if cards[i] then
                        cards[i]:set_edition({ negative = true }, true)
                    end
                end
                SMODS.calculate_context({ playing_card_added = true, cards = cards })
                return true
            end
        }))
        delay(0.3)
    end,
    calculate = function(self, card, context)
        if context.hand_drawn then
            if G.playing_cards then
                local valid_debuffRank_cards = {}
                for _, v in ipairs(G.playing_cards) do
                    if not SMODS.has_no_rank(v) then
                        valid_debuffRank_cards[#valid_debuffRank_cards + 1] = v
                    end
                end
                if valid_debuffRank_cards[1] then
                    local debuffRank_card = pseudorandom_element(valid_debuffRank_cards,
                        pseudoseed('debuffRank' .. G.GAME.round_resets.ante))
                    G.GAME.current_round.debuffRank_card.rank = debuffRank_card.base.value
                    G.GAME.current_round.debuffRank_card.id = debuffRank_card.base.id
                end
            end
            for _, v in ipairs(G.playing_cards) do
                if v.base.value == G.GAME.current_round.debuffRank_card.rank then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.0,
                        func = function()
                            SMODS.debuff_card(v, true, 'c_maxboism_page7')
                            SMODS.recalc_debuff(v)
                            v:juice_up()
                            return true
                        end
                    }))
                else
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.0,
                        func = function()
                            SMODS.debuff_card(v, false, 'c_maxboism_page7')
                            SMODS.recalc_debuff(v)
                            return true
                        end
                    }))
                end
            end
            return {
                message = 'Debuff!'
            }
        end
    end,
    can_use = function(self, card)
        return true
    end,
    set_ability = function(self, card, initial)
        card:set_edition("e_negative", true)
        G.GAME.current_round.debuffRank_card = { rank = '7', id = 7 }
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.current_round.debuffRank_card.rank } }
    end,
    remove_from_deck = function(self, card, from_debuff)
        for _, v in ipairs(G.playing_cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.0,
                func = function()
                    SMODS.debuff_card(v, false, 'c_maxboism_page7')
                    SMODS.recalc_debuff(v)
                    return true
                end
            }))
        end
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
        add_to_deck = function(self, card, from_debuff)
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
}
