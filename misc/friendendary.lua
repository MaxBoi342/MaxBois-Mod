SMODS.ObjectType({
    key = "maxboism_tram", -- The prefix is not added automatically so it's recommended to add it yourself
    default = "j_joker",
    cards = {
        
    },
})

SMODS.ObjectType({
    key = "maxboism_zaza", -- The prefix is not added automatically so it's recommended to add it yourself
    default = "j_joker",
    cards = {
        
    },
})

SMODS.ConsumableType {
    key = 'friend',
    primary_colour = HEX('32003c'),
    secondary_colour = HEX('32003c'),
    collection_rows = { 2 },
    shop_rate = 0,
    cards = {},
    loc_txt = {
        name = "Friend",
        collection = "Friend Cards",
    }
}

SMODS.DrawStep {
    key = 'card_type_shader',
    order = 11,
    func = function(self)
        if (self.ability.set == 'friend' or self.ability.set == 'rune') and self:should_draw_base_shader() then
            self.children.center:draw_shader('booster', nil, self.ARGS.send_to_shader)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.Consumable {
    key = 'thetram',
    set = 'friend',
    pos = { x = 8, y = 0 },
    cost = 0,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
            G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.4,
                  func = function()
                      play_sound('timpani')
                      if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                          G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                      local new_joker = SMODS.add_card({ set = 'maxboism_tram' })
                      if new_joker then
                      end
                          G.GAME.joker_buffer = 0
                      end
                      used_card:juice_up(0.3, 0.5)
                      return true
                  end
              }))
              delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}

SMODS.Consumable {
    key = 'thezaza',
    set = 'friend',
    pos = { x = 9, y = 0 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
            G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.4,
                  func = function()
                      play_sound('timpani')
                      if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                          G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                      local new_joker = SMODS.add_card({ set = 'maxboism_zaza' })
                      if new_joker then
                      end
                          G.GAME.joker_buffer = 0
                      end
                      used_card:juice_up(0.3, 0.5)
                      return true
                  end
              }))
              delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}

G.FUNCS.transform_soul = function(e)
    local soul_card = e.config.ref_table
    soul_card.highlighted = false
    soul_card:open()

    for _, v in ipairs(G.pack_cards.cards) do
    if v == soul_card then
    else
        v:explode()
    end
    end
    --G.FUNCS.end_consumeable()
end