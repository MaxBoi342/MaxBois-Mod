SMODS.DrawStep {
    key = 'back_sticker',
    order = 10,
    func = function(self)
        if G.deck and self == G.deck.cards[1] then
            if G.GAME.MAXBOISM_FERU_COUNT and G.GAME.MAXBOISM_FERU_COUNT > 0 then --
                if not G.deck.cards[1].ability.maxboism_ferureward then
                    SMODS.Stickers['maxboism_ferureward']:set_sticker(self, true)
                end
                G.shared_stickers['maxboism_ferureward'].role.draw_major = self
                local sticker_offset = self.sticker_offset or {}
                G.shared_stickers['maxboism_ferureward']:draw_shader('dissolve', nil, nil, true, self.children.center, nil,
                    self.sticker_rotation, sticker_offset.x, sticker_offset.y)
                G.shared_stickers['maxboism_ferureward']:draw_shader('voucher', nil, self.ARGS.send_to_shader,
                        true, self.children.center, nil, self.sticker_rotation, sticker_offset.x, sticker_offset.y)
            end
        else
            SMODS.Stickers['maxboism_ferureward']:set_sticker(self, false)
        end
    end,
    conditions = { vortex = false, facing = 'back' },
}
