SMODS.Joker { --Cheat Sheet
    key = "cheatsheet",
    config = {
        extra = {
            mult = 15,
            xmult = 2,
            timer = 0
        }
    },
    -- loc_txt = {
    --     ['name'] = 'Cheat Sheet',
    --     ['text'] = {
    --         [1] = 'This joker gives {C:red}+#1#{} Mult on first round played,',
    --         [2] = 'then nothing for two rounds',
    --         [3] = 'and then gives {X:mult,C:white}X#2#{} Mult on the fourth round',
    --         [4] = '{C:inactive}(Currently round {C:attention}#3#{}/4){}'
    --     }
    -- },
    pos = {
        x = 1,
        y = 0
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.xmult, card.ability.extra.timer, } }
    end
}
