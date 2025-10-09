function MaxBoiSM.merge(jokers)
    local copied_joker = nil
    G.E_MANAGER:add_event(Event({
            trigger = 'before',
            func = function()

                copied_joker = SMODS.create_card({ set = 'Joker', key = 'j_maxboism_merged', no_edition = true })

                --local alljokers = MaxBoiSM.recursiveMerge(jokers)
                for i,v in ipairs(jokers) do
                    table.insert(copied_joker.ability.extra.maxboism_multi_boxes, {v.config.center.key, copy_table(v.ability)})
                end
                for i,v in ipairs(jokers) do
                    v:start_dissolve(nil, _first_dissolve)
                end

                copied_joker.ability.extra.maxboism_multi_boxes = MaxBoiSM.recursiveMerge(copied_joker.ability.extra.maxboism_multi_boxes)

                copied_joker:start_materialize()
                copied_joker:add_to_deck()
                G.jokers:emplace(copied_joker)
                _first_dissolve = true
                return true
            end
        }))
    return copied_joker
end