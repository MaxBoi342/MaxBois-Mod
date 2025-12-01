MaxBoiSM.Backsticker {
    key = 'naudizshield',
    rate = 0,
    badge_colour = HEX('1b1a55'),
    default_compat = false,
    sets = {
        Default = true
    },
    config = {
        count = 1
    },
    atlas = 'CustomBackstickers',
    pos = { x = 2, y = 0 },
    set_sticker = function(self, card, val)
        card.ability[self.key] = val
    end,
    loc_vars = function(self, info_queue, card)
    end,
    calculate = function(self, context)
        if context.end_of_round and context.game_over and context.main_eval then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        MaxBoiSM.Backstickers['maxboism_naudizshield']:apply(false)
                        return true
                    end
                }))
                return {
                    message = localize('k_saved_ex'),
                    saved = 'maxboism_naudizshield',
                    colour = G.C.RED
                }
        end
    end
}