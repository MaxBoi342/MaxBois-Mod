SMODS.Back{
    key = "conglomerateB",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    config = {
	},
    atlas = 'CustomDecks',
    apply = function(self)

    end,
    calculate = function(self, back, context)
        if context.ante_change and context.ante_end then
            local eligible_jokers = {}
            for i,v in ipairs(G.jokers.cards) do
                    table.insert(eligible_jokers, v)
            end
            if #eligible_jokers < 2 then return end


            pseudoshuffle(eligible_jokers, 'acquisition')
            MaxBoiSM.merge({eligible_jokers[1], eligible_jokers[2]})
            return {
                message = localize("maxboism_deck_conglomerate_merge"),
                colour = G.C.MONEY
            }
        end
    end,
}

local get_blind_amount_orig = get_blind_amount
function get_blind_amount(ante)
    local normal_amount = get_blind_amount_orig(ante)
    return G.GAME.selected_back.effect.center.key == "b_maxboism_conglomerateB" and (normal_amount * (1.2^#G.jokers.cards)) or normal_amount
end