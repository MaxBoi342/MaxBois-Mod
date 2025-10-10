SMODS.Consumable {
    key = 'page1',
    set = 'page',
    pos = { x = 0, y = 0 },
    config = { 
        extra = {
            edition_amount = 1,
            mult = 0
    } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        return { vars = { localize { type = 'name_text', set = 'Enhanced', key = 'm_mult' } } }
    end,
    -- loc_txt = {
    --     name = 'Page 1',
    --     text = {
    --         [1] = '{C:inactive}Passive:{} All {X:mult,C:white}#1#s{} only provide {C:red}+2{} Mult',
    --         [2] = '{C:default}Active:{} Make a random joker {C:dark_edition}Holographic{}'
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
        local jokers_to_edition = {}
        local eligible_jokers = {}

        if 'editionless' == 'editionless' then
            eligible_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
        else
            for _, joker in pairs(G.jokers.cards) do
                if joker.ability.set == 'Joker' then
                    eligible_jokers[#eligible_jokers + 1] = joker
                end
            end
        end

        if #eligible_jokers > 0 then
            local temp_jokers = {}
            for _, joker in ipairs(eligible_jokers) do
                temp_jokers[#temp_jokers + 1] = joker
            end

            pseudoshuffle(temp_jokers, 76543)

            for i = 1, math.min(card.ability.extra.edition_amount, #temp_jokers) do
                jokers_to_edition[#jokers_to_edition + 1] = temp_jokers[i]
            end
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))

        for _, joker in pairs(jokers_to_edition) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    joker:set_edition({ holo = true }, true)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end,

    calculate = function(self, card, context)
        local multTable = {}
        if context.before then
            for _, check_card in ipairs(context.scoring_hand) do
                    multTable[_] = check_card.ability.mult
                    check_card.ability.mult = card.ability.extra.mult
            end
        end
        if context.final_scoring_step then
            for _, check_card in ipairs(context.scoring_hand) do
                    check_card.ability.mult = multTable[_]
            end
        end
    end,

    set_ability = function(self, card, initial)
        card:set_edition("e_negative", true)
    end,

    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.maxboism_pagecount = G.GAME.maxboism_pagecount and G.GAME.maxboism_pagecount + 1 or 1
                return true
            end
        }))
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.maxboism_pagecount = G.GAME.maxboism_pagecount and G.GAME.maxboism_pagecount > 0 and G.GAME.maxboism_pagecount - 1 or 0
                    return true
            end
        }))
    end,
}
