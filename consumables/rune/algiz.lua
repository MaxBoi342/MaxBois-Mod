SMODS.Consumable {
    key = 'algiz',
    set = 'rune',
    pos = { x = 0, y = 1 },
    config = { extra = {

    } },
    cost = 10,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    can_use = function(self, card)
        if G.STATE and G.STATE == G.STATES.SHOP then
            return true
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {key = 'maxboism_algiztracker', set = 'Other'}
    end,
    calculate = function(self, card, context)
        
    end,
    use = function(self, card, area, copier)
        local used_card = card or copier
                stop_use()
        G.STATE_COMPLETE = false 
        used_card.opening = true
        
        G.STATE = G.STATES.BUFFOON_PACK
        G.GAME.pack_size = 4
        G.GAME.pack_choices = 1
        used_card.states.hover.can = false

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            used_card:explode()
            local pack_cards = {}

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
                local _size = 4
                
                for i = 1, _size do
                    local card = nil  
                        card = create_card("Joker", G.pack_cards, nil, 0.97, true, true, nil, 'alg')

                    card.T.x = used_card.T.x
                    card.T.y = used_card.T.y
                    card:start_materialize({G.C.WHITE, G.C.WHITE}, nil, 1.5*G.SETTINGS.GAMESPEED)
                    card:add_sticker('maxboism_algiztracker', true)
                    pack_cards[i] = card
                end
                return true
            end}))

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
                if G.pack_cards then 
                    if G.pack_cards and G.pack_cards.VT.y < G.ROOM.T.h then 
                    for k, v in ipairs(pack_cards) do
                        G.pack_cards:emplace(v)
                    end
                    return true
                    end
                end
            end}))

        return true end }))
    end,
}