SMODS.Enhancement {
    key = 'maxboism_sand',
    pos = { x = 1, y = 0 },
    config = { x_chips = 1.5 },
    replace_base_card = false,
    no_rank = true,
    no_suit = true,
    overrides_base_rank = false,
    always_scores = true,
    atlas = 'CustomEnhancements',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_chips } }
    end,
    -- loc_txt = {
    --     ['name'] = 'Sand Card',
    --     ['text'] = {
    --         [1] = '{X:chips,C:white}X#1#{} chips',
    --         [2] = 'no suit or rank'
    --     }
    -- },
    calculate = function(self, card, context)
        
    end,
    weight = 2
}

-- I weep over this
-- Update: I no longer weep over this
SMODS.DrawStep {
    key = 'sand_overlay',
    order = 29,
    func = function(self, layer)
        if not G.sand_overlay then
            G.sand_overlay = Sprite(0, 0, G.CARD_W, G.CARD_H,
                G.ASSET_ATLAS['maxboism_CustomEnhancements'], { x = 0, y = 0 })
        end
        
        if SMODS.has_enhancement(self, 'm_maxboism_sand') then
            G.sand_overlay.role.draw_major = self
            G.sand_overlay:draw_shader('dissolve', nil, nil, nil, self.children.center)
            self.base.nominal = 0;
        end
        if not SMODS.has_enhancement(self, 'm_maxboism_sand') then
            self.children.sand_overlay = nil
            if self.base.value == '2' then
                self.base.nominal = 2; self.base.id = 2
            elseif self.base.value == '3' then
                self.base.nominal = 3; self.base.id = 3
            elseif self.base.value == '4' then
                self.base.nominal = 4; self.base.id = 4
            elseif self.base.value == '5' then
                self.base.nominal = 5; self.base.id = 5
            elseif self.base.value == '6' then
                self.base.nominal = 6; self.base.id = 6
            elseif self.base.value == '7' then
                self.base.nominal = 7; self.base.id = 7
            elseif self.base.value == '8' then
                self.base.nominal = 8; self.base.id = 8
            elseif self.base.value == '9' then
                self.base.nominal = 9; self.base.id = 9
            elseif self.base.value == '10' then
                self.base.nominal = 10; self.base.id = 10
            elseif self.base.value == 'Jack' then
                self.base.nominal = 10; self.base.face_nominal = 0.1; self.base.id = 11
            elseif self.base.value == 'Queen' then
                self.base.nominal = 10; self.base.face_nominal = 0.2; self.base.id = 12
            elseif self.base.value == 'King' then
                self.base.nominal = 10; self.base.face_nominal = 0.3; self.base.id = 13
            elseif self.base.value == 'Ace' then
                self.base.nominal = 11; self.base.face_nominal = 0.4; self.base.id = 14
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}
