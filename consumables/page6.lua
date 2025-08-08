SMODS.Consumable {
    key = 'page6',
    set = 'page',
    pos = { x = 5, y = 0 },
    config = { extra = {
        edition_amount = 1
    } },
    loc_txt = {
        name = 'Page 6',
        text = {
            [1] = '{C:inactive}Passive:{} {C:attention}Shuffle{} all jokers when a hand is played',
            [2] = '{C:default}Active:{} Apply {C:dark_edition}Negative{} to a random joker'
        }
    },
    cost = 5,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    calculate = function(self, card, context)
        if context.press_play then
            if #G.jokers.cards > 1 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.jokers:shuffle('c_maxboism_page6')
                                play_sound('cardSlide1', 0.85)
                                return true
                            end,
                        }))
                        delay(0.15)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.jokers:shuffle('c_maxboism_page6')
                                play_sound('cardSlide1', 1.15)
                                return true
                            end
                        }))
                        delay(0.15)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.jokers:shuffle('c_maxboism_page6')
                                play_sound('cardSlide1', 1)
                                return true
                            end
                        }))
                        delay(0.5)
                        return true
                    end
                }))
            end
        end
    end,
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
                    joker:set_edition({ negative = true }, true)
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end,
    set_ability = function(self, card, initial)
        card:set_edition("e_negative", true)
    end
}
