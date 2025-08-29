SMODS.Joker { --Sleeved Joker
    key = "sleevedjoker",
    config = {
        extra = {
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = 'maxboism_lockseal_seal', set = 'Other' }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local nonscoring = {}
            local dont = false
            for _, pcard in ipairs(G.play.cards) do
                for _, p2card in ipairs(context.scoring_hand) do
                    if pcard == p2card then
                        dont = true
                    end
                end
                if dont == false and pcard.seal ~= 'maxboism_lockseal' then
                    table.insert(nonscoring, pcard)
                end
                dont = false
            end

            local toSleeve = pseudorandom_element(nonscoring, "sleever")
            if toSleeve ~= nil then
                return {
                    message = localize('maxboism_joker_sleevedjoker_message'),
                    func = function()
                        toSleeve:set_seal('maxboism_lockseal')
                        -- G.E_MANAGER:add_event(Event({
                        --     trigger = 'after',
                        --     delay = 0.0,
                        --     func = function()
                        --         toSleeve:set_seal('maxboism_lockseal')
                        --         return true
                        --     end
                        -- }))
                    end
                }
            end
        end
    end,
    draw = function(self, card, layer)
        card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
}
