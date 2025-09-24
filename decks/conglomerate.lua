SMODS.Back{
    key = "conglomerate",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    config = {
        joker_slot = -2
	},
    apply = function(self)

    end,
    calculate = function(self, back, context)
        if context.ante_change and context.ante_end then
            local eligible_jokers = {}
            for i,v in ipairs(G.jokers.cards) do
                if v.config.center.blueprint_compat then
                    table.insert(eligible_jokers, v)
                end
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