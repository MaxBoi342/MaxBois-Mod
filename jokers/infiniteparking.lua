SMODS.Joker { --Infinite Parking
    key = "infiniteparking",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Infinite Parking',
        ['text'] = {
            [1] = '{C:attention}1{} card from played hand',
            [2] = 'will not be {C:attention}discarded{}'
        }
    },
    pos = {
        x = 2,
        y = 1
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    calculate = function(self, card, context)
        if context.joker_main then
            local hand = {}
            for _, pcard in ipairs(context.full_hand) do
                if not pcard.config.parked then
                    table.insert(hand, pcard)
                end
            end
            if #hand > 0 then
                local parkedCard = pseudorandom_element(hand, "seed")
                parkedCard.config.parked = true
                return {
                    message = 'Parked!',
                    message_card = parkedCard,
                }
            end
        end
    end
}
