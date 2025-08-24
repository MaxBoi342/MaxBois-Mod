--PLACEHOLDER

SMODS.Shader({ key = 'sepia', path = 'sepia.fs' })

SMODS.Edition({
    key = "sepia",
    discovered = true,
    unlocked = true,
    shader = 'sepia',
    config = {
        percent = 50
    },
    in_shop = true,
    weight = 5,
    extra_cost = 4,
    apply_to_float = true,
    loc_vars = function(self)
        return { vars = { self.config.percent } }
    end,
    calculate = function(self, card, context)
        if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                func = function()
                    balance_percent(card, self.config.percent / 100)
                end
            }
        end
    end

})
