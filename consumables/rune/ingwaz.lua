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
        if G.jokers.highlighted and #G.jokers.highlighted == 1 then
            for i = 1, #G.jokers.cards, 1 do
                if G.jokers.cards[i] == G.jokers.highlighted[1] then
                    if i ~= 1 then

                        if G.jokers.cards[i-1].config.center.blueprint_compat and G.jokers.highlighted[1].config.center.blueprint_compat then
                            return true
                        end
                        
                    end
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)

    end,
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
                MaxBoiSM.merge(joker1, joker2)
                return true
            end
        }))
    end,
}
