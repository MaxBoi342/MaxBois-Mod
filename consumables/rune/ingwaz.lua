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
    set_sprites = function(self, card, front)
        if self.discovered or card.bypass_discovery_center then
            card.children['maxboism_ingwaz_eye'] = Sprite(card.T.x, card.T.y, card.T.w, card.T.h,
                G.ASSET_ATLAS[card.config.center.atlas], {
                    x = 3,
                    y = 1
                })
            card.children['maxboism_ingwaz_eye'].role.draw_major = card
            card.children['maxboism_ingwaz_eye'].states.hover.can = false
            card.children['maxboism_ingwaz_eye'].states.click.can = false
        end
    end,
    soul_pos = nil
}

SMODS.DrawStep {
    key = 'ingwazeye',
    order = -15,
    func = function(card, layer)
        if card.config.center_key == 'c_maxboism_ingwaz' then
            if card.children.maxboism_ingwaz_eye then
                local cursor_pos = { G.CURSOR.T.x, G.CURSOR.T.y }
                local card_eye_pos = { (card.VT.x + (card.VT.w / 2) + G.ROOM.T.x), (card.VT.y + (card.VT.h / 2) + G.ROOM.T.y) }

                local raw_dx = cursor_pos[1] - card_eye_pos[1]
                local raw_dy = cursor_pos[2] - card_eye_pos[2]

                local max_radius = math.min(card.VT.w / 71 * 5, card.VT.h / 95 * 5)

                local distance = math.sqrt(raw_dx ^ 2 + raw_dy ^ 2)
                local dx = 0
                local dy = 0
                if distance > max_radius * 2 then
                    dx = (raw_dx / distance) * max_radius
                    dy = (raw_dy / distance) * max_radius
                else
                    dx = raw_dx / 2
                    dy = raw_dy / 2
                end
                
                card.children.maxboism_ingwaz_eye:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, nil, dx, dy,
                    nil, nil)
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys.maxboism_ingwaz_eye = true
