SMODS.Joker {
    key = "optimizedpacking",
    config = {
        extra = {
            count = 0
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    set_ability = function(self, card, initial)
    end,

    calculate = function(self, card, context)

    end,
    remove_from_deck = function(self, card, from_debff)
        G.GAME.starting_params.play_limit = G.GAME.starting_params.play_limit - card.ability.extra.count
    end
}

local can_highlight_orig = CardArea.add_to_highlighted

local remove_highlight_orig = CardArea.remove_from_highlighted

function CardArea:remove_from_highlighted(card, force)
    if self.config.type == 'hand' and next(SMODS.find_card("j_maxboism_optimizedpacking")) then
        if (not force) and  card and card.ability.forced_selection and self == G.hand then return end
    for i = #self.highlighted,1,-1 do
        if self.highlighted[i] == card then
            table.remove(self.highlighted, i)
            break
        end
    end
    if SMODS.always_scores(card) then
                local jokerCard = SMODS.find_card("j_maxboism_optimizedpacking")[1]
                jokerCard.ability.extra.count = jokerCard.ability.extra.count - 1
                G.GAME.starting_params.play_limit = G.GAME.starting_params.play_limit - 1
            end
    card:highlight(false)
    if self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
        self:parse_highlighted()
    end
    else
        remove_highlight_orig(self, card, force)
    end

end

function CardArea:add_to_highlighted(card, silent)
    if self.config.type == 'hand' and next(SMODS.find_card("j_maxboism_optimizedpacking")) then
        if #self.highlighted >= self.config.highlighted_limit and not SMODS.always_scores(card) then
            card:highlight(false)
        else
            self.highlighted[#self.highlighted+1] = card
            card:highlight(true)
            if SMODS.always_scores(card) then
                local jokerCard = SMODS.find_card("j_maxboism_optimizedpacking")[1]
                jokerCard.ability.extra.count = jokerCard.ability.extra.count + 1
                G.GAME.starting_params.play_limit = G.GAME.starting_params.play_limit + 1
            end
            if not silent then play_sound('cardSlide1') end
        end
        if self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
            self:parse_highlighted()
        end
    else
        can_highlight_orig(self, card, silent)
    end
end
