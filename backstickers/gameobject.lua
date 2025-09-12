MaxBoiSM.BackStickers = {}
MaxBoiSM.BackSticker = SMODS.GameObject:extend {
    obj_table = MaxBoiSM.BackStickers,
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
        MaxBoiSM.BackSticker.super.register(self)
        self.order = #self.obj_buffer
    end,
    inject = function(self)
        self.backsticker_sprite = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS[self.atlas], self.pos)
        MaxBoiSM.shared_backstickers[self.key] = self.backsticker_sprite
    end,
    apply = function(self, val)
        if not G.GAME.backsticker then
                G.GAME.backsticker = {}
            end
        G.GAME.backsticker[self.key] = val
        if val and self.config and next(self.config) then
            G.GAME.backsticker[self.key] = {}
            for k, v in pairs(self.config) do
                if type(v) == 'table' then
                    G.GAME.backsticker[self.key][k] = copy_table(v)
                else
                    G.GAME.backsticker[self.key][k] = v
                end
            end
        end
    end
}

MaxBoiSM.BackSticker {
    key = 'ferureward',
    rate = 0,
    badge_colour = HEX('1b1a55'),
    default_compat = false,
    sets = {
        Default = true
    },
    atlas = 'CustomStickers',
    pos = { x = 0, y = 0 },
    set_sticker = function(self, card, val)
        card.ability[self.key] = val
    end,
    calculate = function(self, card, context)
        if context.money_altered and to_big(context.amount) > to_big(0)then
            MaxBoiSM.DISABLE_MONEY_REPEATS = true
            return {
                dollars = to_number(context.amount),
                func = function()
                    MaxBoiSM.DISABLE_MONEY_REPEATS = false
                end
            }
        end
        if context.individual and context.cardarea == G.play then
            return {
                mult = 4
            }
        end
    end
}

function Card:calculate_backsticker(context, key)
    local backsticker = MaxBoiSM.BackStickers[key]
    if self.ability[key] and type(backsticker.calculate) == 'function' then
        local o = backsticker:calculate(self, context)
        if o then
            if not o.card then o.card = self end
            return o
        end
    end
end

SMODS.DrawStep {
    key = 'back_sticker',
    order = 10,
    func = function(self)
        if G.deck and self == G.deck.cards[1] then
            for _,v in ipairs(MaxBoiSM.BackSticker.obj_buffer) do
                local backsticker = MaxBoiSM.BackStickers[v]
                if G.GAME.backsticker and G.GAME.backsticker[backsticker.key] then
                MaxBoiSM.shared_backstickers[backsticker.key].role.draw_major = self
                    local sticker_offset = self.sticker_offset or {}
                MaxBoiSM.shared_backstickers['maxboism_ferureward']:draw_shader('dissolve', nil, nil, true, self.children.center, nil,
                    self.sticker_rotation, sticker_offset.x, sticker_offset.y)
                MaxBoiSM.shared_backstickers['maxboism_ferureward']:draw_shader('voucher', nil, self.ARGS.send_to_shader,
                        true, self.children.center, nil, self.sticker_rotation, sticker_offset.x, sticker_offset.y)
                end
            end
        end
    end,
    conditions = { vortex = false, facing = 'back' },
}
