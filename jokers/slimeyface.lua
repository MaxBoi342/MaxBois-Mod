SMODS.Joker {
    key = "slimeyface",
    config = {

    },
    pos = {
        x = 6,
        y = 1
    },
    cost = 4,
    rarity = "maxboism_fusion",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)

    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local id = context.other_card:get_id()
            if context.other_card:is_face() then
                local ranktally = 0
                local facetally = 0
                for _, playing_card in ipairs(G.playing_cards) do
                    if playing_card:get_id() == id then ranktally = ranktally + 1 end
                    if playing_card:is_face() then facetally = facetally + 1 end
                end
                return {
                    mult = ranktally,
                    chips = facetally,
                }
            end
        end
        -- return {
        --     func = function()
        --         play_sound("maxboism_throwinggrenade")
        --     end
        -- }
    end,
}