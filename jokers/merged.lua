SMODS.Joker {
    key = "merged",
    config = {
        extra = {
            maxboism_multi_boxes = {
            },
            totalreturn = 0
        }
    },
    pos = {
        x = -1,
        y = -1
    },
    no_collection = true,
    cost = 0,
    rarity = "maxboism_merged",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    loc_vars = function(self, info_queue, card)
        --local all_boxes = MaxBoiSM.recursiveMerge(card.ability.extra.maxboism_multi_boxes)
    end,
    calculate = function(self, card, context)
        local totalreturn = {}
        if context.end_of_round then
            card.ability.extra.totalreturn = 0
        end
        if card.ability.extra.maxboism_multi_boxes then
            for i, v in ipairs(card.ability.extra.maxboism_multi_boxes) do
                local key = v[1]
                G.maxboism_savedjokercards = G.maxboism_savedjokercards or {}
                G.maxboism_savedjokercards[card.sort_id] = G.maxboism_savedjokercards[card.sort_id] or {}
                if not G.maxboism_savedjokercards[card.sort_id][key] then
                    local old_ability = copy_table(card.ability)
                    local old_center = card.config.center
                    local old_center_key = card.config.center_key
                    card:set_ability(key, nil, 'quantum')
                    card:update(0.016)
                    card.ability = v[2]
                    G.maxboism_savedjokercards[card.sort_id][key] = SMODS.shallow_copy(card)
                    G.maxboism_savedjokercards[card.sort_id][key].ability = copy_table(G.maxboism_savedjokercards
                        [card.sort_id][key].ability)
                    for i, v in ipairs({ "T", "VT", "CT" }) do
                        G.maxboism_savedjokercards[card.sort_id][key][v] = copy_table(G.maxboism_savedjokercards
                            [card.sort_id][key][v])
                    end
                    G.maxboism_savedjokercards[card.sort_id][key].config = SMODS.shallow_copy(G
                        .maxboism_savedjokercards
                        [card.sort_id][key].config)
                    card.ability = old_ability
                    card.config.center = old_center
                    card.config.center_key = old_center_key
                    for i, v in ipairs({ 'juice_up', 'start_dissolve', 'remove', 'flip' }) do
                        G.maxboism_savedjokercards[card.sort_id][key][v] = function(_, ...)
                            return card[v](card, ...)
                        end
                    end
                end
                local partreturn = G.maxboism_savedjokercards[card.sort_id][key]:calculate_joker(context)
                card.ability.extra.maxboism_multi_boxes[i][2] = G.maxboism_savedjokercards[card.sort_id][key].ability
                if type(partreturn) == 'table' then
                    totalreturn = SMODS.merge_effects({ totalreturn, partreturn })
                end
            end
            if next(totalreturn) ~= nil then
                return totalreturn
            else
                return false
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.maxboism_multi_boxes then
            for i, v in ipairs(card.ability.extra.maxboism_multi_boxes) do
                local key = v[1]
                local partreturn = G.maxboism_savedjokercards[card.sort_id][key]:calculate_dollar_bonus()
                if partreturn then
                    card.ability.extra.totalreturn = card.ability.extra.totalreturn + G.maxboism_savedjokercards[card.sort_id][key]:calculate_dollar_bonus()
                end
                
            end
            if card.ability.extra.totalreturn == 0 then
                
            else
                return card.ability.extra.totalreturn
            end
        end
    end
}

SMODS.DrawStep {
    key = 'sand_overlay',
    order = 29,
    func = function(self, layer)
        if self.config.center.key == 'j_maxboism_merged' then
            local keys = self.ability.extra.maxboism_multi_boxes
            local fractions = #keys
            for i, v in ipairs(keys) do
                local fraction = i

                G.shared_fractioned_cards = G.shared_fractioned_cards or {}
                G.shared_fractioned_cards[fractions] = G.shared_fractioned_cards[fractions] or {}
                G.shared_fractioned_cards[fractions][fraction] = G.shared_fractioned_cards[fractions][fraction] or {}

                local key = v[1]
                if G.P_CENTERS[key].pos and not G.shared_fractioned_cards[fractions][fraction][key] then
                    G.shared_fractioned_cards[fractions][fraction][key] = G.shared_fractioned_cards[fractions][fraction]
                        [key] or {}
                    G.shared_fractioned_cards[fractions][fraction][key].center = Sprite(0, 0, 71, 95,
                        G.ASSET_ATLAS[G.P_CENTERS[key].atlas or G.P_CENTERS[key].set or 'Joker'], G.P_CENTERS[key].pos)
                    local x, y, w, h = G.shared_fractioned_cards[fractions][fraction][key].center.sprite:getViewport()
                    local fractionedw = w / fractions
                    G.shared_fractioned_cards[fractions][fraction][key].center.sprite = love.graphics.newQuad(
                        x + (fractionedw * (fraction - 1)), y, fractionedw, h,
                        unpack(G.shared_fractioned_cards[fractions][fraction][key].center.image_dims))
                    G.shared_fractioned_cards[fractions][fraction][key].center:set_role({
                        major = self,
                        role_type =
                        'Glued',
                        draw_major = self
                    })
                    G.shared_fractioned_cards[fractions][fraction][key].center:draw_shader('dissolve', nil, nil, nil,
                        self.children.center, nil, nil, ((G.CARD_W / fractions) * (fraction - 1)))
                elseif G.shared_fractioned_cards[fractions][fraction][key] then
                    G.shared_fractioned_cards[fractions][fraction][key].center:set_role({
                        major = self,
                        role_type =
                        'Glued',
                        draw_major = self
                    })
                    G.shared_fractioned_cards[fractions][fraction][key].center:draw_shader('dissolve', nil, nil, nil,
                        self.children.center, nil, nil, ((G.CARD_W / fractions) * (fraction - 1)))
                end
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}
