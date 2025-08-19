SMODS.Seal {
    key = 'lockseal',
    pos = { x = 0, y = 0 },
    badge_colour = HEX('888888'),
    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    calculate = function(self, card, context)
        if context.destroying_Card then
        end
    end,
    update = function(self, card, dt)
            if card.debuff then
                SMODS.destroy_cards(card, false, true)
            end
    end

}

SMODS.DrawStep {
    key = 'card_sleeve',
    order = 32,
    func = function(self, layer)
        if self.seal == 'maxboism_lockseal' then
            self.children.center:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}


