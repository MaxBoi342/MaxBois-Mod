SMODS.Joker {
    key = "maketheskyfall",
    config = {
        extra = {
        }
    },
    pos = {
        x = 7,
        y = 1
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "maxboism_blindindicator_theskyboss", set = "Other"}
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            for i,v in pairs(G.GAME.round_resets.blind_choices) do
                if v ~= "bl_maxboism_thesky" then
                    if i == 'Small' then
                        G.GAME.round_resets.blind_choices[i] = "bl_maxboism_theskysmall"
                    elseif i == 'Big' then
                        G.GAME.round_resets.blind_choices[i] = "bl_maxboism_theskybig"
                    else 
                        G.GAME.round_resets.blind_choices[i] = "bl_maxboism_theskyboss"
                    end
                end
            end
        end
    end,
}

local get_current_music_ref = SMODS.Sound.get_current_music

function SMODS.Sound:get_current_music()
    if next(SMODS.find_card("j_maxboism_maketheskyfall")) then
        return ''
    else
        return get_current_music_ref(self)
    end
end