SMODS.Consumable {
    key = 'ingwaz',
    set = 'rune',
    pos = { x = 0, y = 1 },
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
                        return true
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
        local joker1_copy = copy_card(G.jokers.highlighted[1])
        local joker1 = G.jokers.highlighted[1]
        local joker2_copy = nil
        local joker2 = nil

        for i = 1, #G.jokers.cards, 1 do
            if G.jokers.cards[i] == joker1 then
                if i ~= 1 then
                    joker2_copy = copy_card(G.jokers.cards[i - 1])
                    joker2 = G.jokers.cards[i - 1]
                end
            end
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.75,
            func = function()
                G.maxboism_merged_area:emplace(joker1_copy)
                G.maxboism_merged_area:emplace(joker2_copy)

                local copied_joker = SMODS.create_card({ set = 'Joker', key = 'j_maxboism_merged', no_edition = true })

                for i, v in ipairs(G.maxboism_merged_area.cards) do
                    if v == joker1_copy or v == joker2_copy then
                        table.insert(copied_joker.ability.extra.maxboism_multi_boxes, 1, i)
                    end
                end

                joker1:start_dissolve(nil, _first_dissolve)
                joker2:start_dissolve(nil, _first_dissolve)

                copied_joker:start_materialize()
                copied_joker:add_to_deck()
                G.jokers:emplace(copied_joker)
                _first_dissolve = true
                return true
            end
        }))
    end,
}
