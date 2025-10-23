MaxBoiSM.Backstickers = {}
MaxBoiSM.Backsticker = SMODS.GameObject:extend {
    obj_table = MaxBoiSM.Backstickers,
    obj_buffer = {},
    set = 'BackSticker',
    required_params = {
        'key',
    },
    rate = 0,
    atlas = 'stickers',
    pos = { x = 0, y = 0 },
    badge_colour = HEX 'FFFFFF',
    default_compat = false,
    compat_exceptions = {},
    sets = { Default = true },
    needs_enable_flag = false,
    process_loc_text = function(self)
        SMODS.process_loc_text(G.localization.descriptions.Other, self.key, self.loc_txt)
        SMODS.process_loc_text(G.localization.misc.labels, self.key, self.loc_txt, 'label')
    end,
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end
        MaxBoiSM.Backsticker.super.register(self)
        self.order = #self.obj_buffer
    end,
    inject = function(self)
        self.backsticker_sprite = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS[self.atlas], self.pos)
        MaxBoiSM.shared_backstickers[self.key] = self.backsticker_sprite
    end,
    apply = function(self, val)
        if not self.config then
            G.GAME.backsticker[self.key] = val
        elseif val and self.config and next(self.config) and not G.GAME.backsticker[self.key] then
            G.GAME.backsticker[self.key] = {}
            for k, v in pairs(self.config) do
                if type(v) == 'table' then
                    G.GAME.backsticker[self.key][k] = copy_table(v)
                else
                    G.GAME.backsticker[self.key][k] = v
                end
            end
        elseif val and self.config and next(self.config) and G.GAME.backsticker[self.key] then
            for k, v in pairs(self.config) do
                if type(v) == 'table' then
                    G.GAME.backsticker[self.key][k] = copy_table(v)
                else
                    G.GAME.backsticker[self.key][k] = G.GAME.backsticker[self.key][k] + v
                end
            end
        elseif not val and self.config and next(self.config) and G.GAME.backsticker[self.key] then
            for k, v in pairs(self.config) do
                if type(v) == 'table' then
                    G.GAME.backsticker[self.key][k] = copy_table(v)
                else
                    G.GAME.backsticker[self.key][k] = G.GAME.backsticker[self.key][k] - v
                end
                if G.GAME.backsticker[self.key][k] == 0 then
                    G.GAME.backsticker[self.key] = false
                    break
                end
            end
        end
    end
}

-- MaxBoiSM.Backsticker {
--     key = 'teststicker',
--     rate = 0,
--     badge_colour = HEX('1b1a55'),
--     default_compat = false,
--     sets = {
--         Default = true
--     },
--     atlas = 'CustomStickers',
--     pos = { x = 0, y = 0 },
--     set_sticker = function(self, card, val)
--         card.ability[self.key] = val
--     end,
--     calculate = function(self, context)
--             if context.end_of_round and not context.repetition and not context.individual then
--                 return {
--                     dollars = 10
--                 }
--             end
--     end
-- }

SMODS.DrawStep {
    key = 'back_sticker',
    order = 10,
    func = function(self)
        if G.deck and self == G.deck.cards[1] then
            for _, v in ipairs(MaxBoiSM.Backsticker.obj_buffer) do
                local backsticker = MaxBoiSM.Backstickers[v]
                if G.GAME.backsticker and G.GAME.backsticker[backsticker.key] then
                    MaxBoiSM.shared_backstickers[backsticker.key].role.draw_major = self
                    local sticker_offset = self.sticker_offset or {}
                    MaxBoiSM.shared_backstickers[backsticker.key]:draw_shader('dissolve', nil, nil, true,
                        self.children.center, nil,
                        self.sticker_rotation, sticker_offset.x, sticker_offset.y)
                    MaxBoiSM.shared_backstickers[backsticker.key]:draw_shader('voucher', nil,
                    self.ARGS.send_to_shader,
                        true, self.children.center, nil, self.sticker_rotation, sticker_offset.x, sticker_offset.y)
                end
            end
        end
    end,
    conditions = { vortex = false, facing = 'back' },
}
