SMODS.Joker {
    key = "merged",
    config = {
        extra = {
            maxboism_multi_boxes = {
            }
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    no_collection = true,
    cost = 0,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    loc_vars = function(self, info_queue, card)
        local all_boxes = MaxBoiSM.recursiveMerge(card.ability.extra.maxboism_multi_boxes)
    end,
    calculate = function(self, card, context)
        local totalreturn = {}
        local all_boxes = MaxBoiSM.recursiveMerge(card.ability.extra.maxboism_multi_boxes)
        for i, v in ipairs(all_boxes) do
            local partreturn = SMODS.blueprint_effect(card, G.maxboism_merged_area.cards[v], context)
            totalreturn = SMODS.merge_effects({ totalreturn, partreturn })
        end
        return totalreturn
    end,
    remove_from_deck = function(self, card, from_debuff)
        if next(SMODS.find_card('j_maxboism_merged')) then return end
        if G.maxboism_merged_area.cards then
            for _, v in ipairs(SMODS.shallow_copy(G.maxboism_merged_area.cards)) do
                v:remove()
            end
        end
    end
}

SMODS.DrawStep {
    key = 'sand_overlay',
    order = 29,
    func = function(self, layer)
        if self.config.center.key == 'j_maxboism_merged' then
            local total_jokers = MaxBoiSM.recursiveMerge(self.ability.extra.maxboism_multi_boxes)
            local fractions = #total_jokers
            for i, v in ipairs(total_jokers) do
                local fraction = i

                G.shared_fractioned_cards = G.shared_fractioned_cards or {}
                G.shared_fractioned_cards[fractions] = G.shared_fractioned_cards[fractions] or {}
                G.shared_fractioned_cards[fractions][fraction] = G.shared_fractioned_cards[fractions][fraction] or {}

                local key = G.maxboism_merged_area.cards[v].config.center.key
                if G.P_CENTERS[key].pos and not G.shared_fractioned_cards[fractions][fraction][key] then
                    G.shared_fractioned_cards[fractions][fraction][key] = G.shared_fractioned_cards[fractions][fraction][key] or {}
                    G.shared_fractioned_cards[fractions][fraction][key].center = Sprite(0, 0, 71, 95,
                        G.ASSET_ATLAS[G.P_CENTERS[key].atlas or G.P_CENTERS[key].set or 'Joker'], G.P_CENTERS[key].pos)
                    local x, y, w, h = G.shared_fractioned_cards[fractions][fraction][key].center.sprite:getViewport()
                    local fractionedw = w / fractions
                    G.shared_fractioned_cards[fractions][fraction][key].center.sprite = love.graphics.newQuad(
                        x + (fractionedw * (fraction - 1)), y, fractionedw, h,
                        unpack(G.shared_fractioned_cards[fractions][fraction][key].center.image_dims))
                        G.shared_fractioned_cards[fractions][fraction][key].center:set_role({major = self, role_type = 'Glued', draw_major = self})
                        G.shared_fractioned_cards[fractions][fraction][key].center:draw_shader('dissolve', nil, nil, nil, self.children.center, nil, nil, ((G.CARD_W/fractions)*(fraction-1)))
                elseif G.shared_fractioned_cards[fractions][fraction][key] then
                    G.shared_fractioned_cards[fractions][fraction][key].center:set_role({major = self, role_type = 'Glued', draw_major = self})
                    G.shared_fractioned_cards[fractions][fraction][key].center:draw_shader('dissolve', nil, nil, nil, self.children.center, nil, nil, ((G.CARD_W/fractions)*(fraction-1)))
                end
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}
