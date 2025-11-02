SMODS.Consumable {
    key = 'ingwaz',
    set = 'rune',
    pos = { x = 2, y = 1 },
    config = { extra = {
    } },
    cost = 10,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    can_use = function(self, card)
        if G.GAME.round_resets.blind_states.Small == "Select" then
            if G.jokers.highlighted and #G.jokers.highlighted == 1 then
                for i = 1, #G.jokers.cards, 1 do
                    if G.jokers.cards[i] == G.jokers.highlighted[1] then
                        if i ~= 1 then
                            return true
                        end
                    end
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'maxboism_ingwaztracker', set = 'Other' }
    end,
    select_card = "consumeables",
    calculate = function(self, card, context)

    end,
    use = function(self, card, area, copier)
        local used_card = card or copier
        local joker1 = G.jokers.highlighted[1]
        local joker2 = nil

        for i = 1, #G.jokers.cards, 1 do
            if G.jokers.cards[i] == joker1 then
                if i ~= 1 then
                    joker2 = G.jokers.cards[i - 1]
                end
            end
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.75,
            func = function()
                joker1:add_sticker("maxboism_ingwaztracker", true)
                joker2:add_sticker("maxboism_ingwaztracker", true)
                joker1.ability.maxboism_ingwazid = card.sort_id
                joker1.ability.maxboism_ingwazorder = 2
                joker2.ability.maxboism_ingwazid = card.sort_id
                joker2.ability.maxboism_ingwazorder = 1
                SMODS.debuff_card(joker1, true, "ingwaz")
                SMODS.debuff_card(joker2, true, "ingwaz")

                return true
            end
        }))
    end,
}
