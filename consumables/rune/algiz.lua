SMODS.Consumable {
    key = 'algiz',
    set = 'rune',
    pos = { x = 1, y = 1 },
    config = { extra = {

    } },
    cost = 10,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    can_use = function(self, card)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'maxboism_algiztracker', set = 'Other' }
    end,
    calculate = function(self, card, context)

    end,
    use = function(self, card, area, copier)
        local used_card = card or copier
        used_card:pseudo_open({ draw_hand = false, choose = 1, extra = 4, background_color = { HEX('b22e2e'), HEX('6b2009') }, create_card = function(
            self, card, i)
            local _card = create_card("Joker", G.pack_cards, nil, 0.97, true, true, nil, 'alg'); _card:add_sticker(
            'maxboism_algiztracker', true); return _card
        end, })
    end,
}
