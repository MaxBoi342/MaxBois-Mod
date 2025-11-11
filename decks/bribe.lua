SMODS.Scoring_Parameter({
	key = 'bribe',
	default_value = 0,
	colour = mix_colours(G.C.PURPLE, G.C.YELLOW, 0.5),
	calculation_keys = { 'bribe' },
	modify = function(self, amount)
		self.current = amount -- update the current value, used for final score calculation
		self.default_value = self.current -- update the default value
		update_hand_text({delay = 0}, {[self.key] = self.current})
	end,
	hands = {},
	level_up_hand = function(self, amount, handType)
	end,
})

SMODS.Scoring_Calculation({
	key = "bribe",
	func = function(self, chips, mult, flames)
		return (chips + mult) * SMODS.get_scoring_parameter(self.mod.prefix .. '_bribe', flames)
	end,
	parameters = { 'chips', 'mult', SMODS.current_mod.prefix .. '_bribe' },
	replace_ui = function(self)
		local scale = 0.3
		return
		{
			n = G.UIT.R,
			config = { align = "cm", minh = 1, padding = 0.1 },
			nodes = {
				{
					n = G.UIT.T,
					config = { align = 'cm', text = '(', scale=scale },
				},
				{
					n = G.UIT.C,
					config = { align = 'cm', id = 'hand_chips' },
					nodes = {
						SMODS.GUI.score_container({
							type = 'chips',
							text = 'chip_text',
							align = 'cr',
							w = 1.1,
							scale = scale
						})
					}
				},
				{
					n = G.UIT.T,
					config = { align = 'cm', text = '+', scale=scale },
				},
				{
					n = G.UIT.C,
					config = { align = 'cm', id = 'hand_mult' },
					nodes = {
						SMODS.GUI.score_container({
							type = 'mult',
							align = 'cm',
							w = 1.1,
							scale = scale
						})
					}
				},
				{
					n = G.UIT.T,
					config = { align = 'cm', text = ')', scale=scale },
				},
				SMODS.GUI.operator(scale * 0.75),
				{
					n = G.UIT.C,
					config = { align = 'cm', id = 'hand_' .. self.mod.prefix .. '_bribe' },
					nodes = {
						SMODS.GUI.score_container({
							type = self.mod.prefix .. '_bribe',
							align = 'cl',
							w = 1.1,
							scale = scale
						})
					}
				},
			}
		}
	end
})

SMODS.Back {
	key = "bribe",
	pos = { x = 0, y = 0 },
	unlocked = true,
	discovered = true,
	config = {
		-- extra_hand_bonus = 0,
		maxboism_interest = 3,
		reset_round = true
	},
	atlas = 'CustomDecks',
	apply = function(self)
		G.GAME.current_scoring_calculation = SMODS.Scoring_Calculations['maxboism_bribe']:new()
		G.GAME.modifiers.maxboism_invert_hand_money = true
	end,
	calculate = function(self, back, context)
		if context.final_scoring_step then
			return {
				bribe = G.GAME.dollars + (G.GAME.dollar_buffer or 0)
			}
		end
	end,
}

-- local set_cost_orig = Card.set_cost

-- function Card:set_cost()
-- 	if G and G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_maxboism_bribe" then
-- 		self.base_cost = self.base_cost * 2
-- 	end
-- 	set_cost_orig(self)
-- end

-- local cash_out_orig = G.FUNCS.cash_out

-- G.FUNCS.cash_out = function(e)
-- 	if G and G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == "b_maxboism_bribe" then
-- 		G.E_MANAGER:add_event(Event({
--           func = function()
--             SMODS.set_scoring_calculation("maxboism_bribe")
--             return true
--           end
--         }))
-- 	end
-- 	cash_out_orig(e)
-- end

SMODS.Scoring_Parameter({
  key = 'juice',
  default_value = 0,
  colour = mix_colours(G.C.PURPLE, G.C.YELLOW, 0.5),
  calculation_keys = {'juice', 'xjuice'},
  hands = {
        ['Pair'] = {[SMODS.current_mod.prefix..'_juice'] = 10, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 10},
        ['Four of a Kind'] = {[SMODS.current_mod.prefix..'_juice'] = 10, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 10},
        ["Flush Five"] = {[SMODS.current_mod.prefix..'_juice'] = 1, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 1},
        ["Flush House"] = {[SMODS.current_mod.prefix..'_juice'] = 1, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 1},
        ["Five of a Kind"] = {[SMODS.current_mod.prefix..'_juice'] = 1, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 1},
        ["Straight Flush"] = {[SMODS.current_mod.prefix..'_juice'] = 1, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 1},
        ["Full House"] = {[SMODS.current_mod.prefix..'_juice'] = 1, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 1},
        ["Flush"] = {[SMODS.current_mod.prefix..'_juice'] = 1, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 1},
        ["Straight"] = {[SMODS.current_mod.prefix..'_juice'] = 1, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 1},
        ["Three of a Kind"] = {[SMODS.current_mod.prefix..'_juice'] = 1, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 1},
        ["Two Pair"] = {[SMODS.current_mod.prefix..'_juice'] = 1, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 1},
        ["High Card"] = {[SMODS.current_mod.prefix..'_juice'] = 1, ['l_'..SMODS.current_mod.prefix..'_juice'] = 5, ['s_'..SMODS.current_mod.prefix..'_juice'] = 1},
    },
    calc_effect = function(self, effect, scored_card, key, amount, from_edition)
		if not SMODS.Calculation_Controls.chips then return end
	    if key == 'juice' and amount then
	        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
	        self:modify(amount)
	        card_eval_status_text(scored_card, 'extra', nil, percent, nil,
	            {message = localize{type = 'variable', key = amount > 0 and 'a_chips' or 'a_chips_minus', vars = {amount}}, colour = self.colour})
	        return true
        end
        if key == 'xjuice' and amount then
            if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
            self:modify(self.current * (amount - 1))
            card_eval_status_text(scored_card, 'extra', nil, percent, nil,
                {message = localize{type = 'variable', key = amount > 0 and 'a_chips' or 'a_chips_minus', vars = {'X'..amount}}, colour = self.colour})
            return true
        end
    end
})

SMODS.Scoring_Calculation({
    key = "juice",
    func = function(self, chips, mult, flames)
	    return chips * mult * SMODS.get_scoring_parameter(self.mod.prefix..'_juice', flames)
	end,
    parameters = {'chips', 'mult', SMODS.current_mod.prefix..'_juice'},
    replace_ui = function(self)
        local scale = 0.3
		return
		{n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
			{n=G.UIT.C, config={align = 'cm', id = 'hand_chips'}, nodes = {
				SMODS.GUI.score_container({
					type = 'chips',
					text = 'chip_text',
					align = 'cr',
					w = 1.1,
					scale = scale
				})
			}},
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_mult'}, nodes = {
				SMODS.GUI.score_container({
					type = 'mult',
					align = 'cm',
					w = 1.1,
					scale = scale
				})
			}},
			SMODS.GUI.operator(scale*0.75),
			{n=G.UIT.C, config={align = 'cm', id = 'hand_maxboism_juice'}, nodes = {
				SMODS.GUI.score_container({
					type = 'maxboism_juice',
					align = 'cl',
					w = 1.1,
					scale = scale
				})
			}},
		}}
	end
})

