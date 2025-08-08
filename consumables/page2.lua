SMODS.Consumable {
    key = 'page2',
    set = 'page',
    pos = { x = 1, y = 0 },
    config = { extra = {
        consumable_count = 1,
        dollars = 1,
        coupon = 0
    } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_coupon', set = 'Tag' }
        return { vars = { localize { type = 'name_text', set = 'Tag', key = 'tag_coupon' } } }
    end,
    loc_txt = {
        name = 'Page 2',
        text = {
            [1] = '{C:inactive}Passive:{} Lose {C:money}$1{} per hand played',
            [2] = '{C:default}Active:{} Create a {C:attention}#1#{}',
            [3] = '{C:inactive}(If used inside shop. trigger the tag){}'
        }
    },
    cost = 5,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        if G.shop and not G.GAME.shop_free then
            G.GAME.shop_free = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.shop_jokers and G.shop_booster then
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        for _, card in pairs(G.shop_jokers.cards) do
                            card.ability.couponed = true
                            card:set_cost()
                        end
                        for _, booster in pairs(G.shop_booster.cards) do
                            booster.ability.couponed = true
                            booster:set_cost()
                        end
                    end
                    return true
                end
            }))
            card.triggered = true
            return true
        else
            G.E_MANAGER:add_event(Event({
                func = function()
                    local tag = Tag("tag_coupon")
                    if tag.name == "Orbital Tag" then
                        local _poker_hands = {}
                        for k, v in pairs(G.GAME.hands) do
                            if v.visible then
                                _poker_hands[#_poker_hands + 1] = k
                            end
                        end
                        tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "jokerforge_orbital")
                    end
                    tag:set_ability()
                    add_tag(tag)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end
            }))
        end
    end,
    calculate = function(self, card, context)
        if context.after then
            return {
                dollars = -card.ability.extra.dollars,
                message = "Mine!"
            }
        end
    end,

    can_use = function(self, card)
        return true
    end,
    set_ability = function(self, card, initial)
        card:set_edition("e_negative", true)
    end
}
