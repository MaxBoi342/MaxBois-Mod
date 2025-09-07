---@diagnostic disable: unused-local, redefined-local, missing-fields, inject-field
function Card:pseudo_open(args)
    G.GAME.maxboism_pseudo_open_active = true
    assert(type(args.choose) == 'number', "Provide how many cards are picked with 'choose = x'")
    assert(type(args.extra) == 'number', "Provide how many cards are chosen from with 'extra = x'")
    assert(type(args.create_card) == 'function',
        "please provide a card creating function with create_card = function(self, card, i)")
    assert(type(args.background_color) == 'table' and #args.background_color == 2,
        "Provide colors with a table with 2 entries with 'background_color = {x,y}'")
    assert(type(args.draw_hand) == 'boolean',
        "Plrase provide if the hand should be drawn or not with 'draw_hand == true or false'")

    local functiontoBe
    if args.sparkles and assert(type(args.sparkles) == 'function', "args.sparkles must be a function") then
        functiontoBe = args.sparklses
    else
        functiontoBe = function()

        end
    end
    self.config.center = {
        group_key = "k_maxboism_what",
        name = "???",
        kind = '???',
        key = 'p_arcana_normal_1',
        draw_hand = args.draw_hand,
        update_pack = SMODS.Booster.update_pack,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, args.background_color[1])
            ease_background_colour({ new_colour = args.background_color[1], special_colour = args.background_color[2], contrast = 2 })
        end,
        create_UIBox = SMODS.Booster.create_UIBox,
        particles = functiontoBe,
        create_card = args.create_card,
        loc_vars = function(self, info_queue, card)
            return {
                vars = { args.choose, args.extra }
            }
        end,
    }
    self.cost = 0
    self.config.pseudo_open = true
    self.ability.extra = args.extra
    self.config.center.config = {
        choose = args.choose
    }

    draw_card(self.area, G.play, 1, 'up', true, self, nil, true)
    if G.hand and #G.hand.cards > 0 then
        G.FUNCS.draw_from_hand_to_deck()
        delay(0.65)
    end

    self:open()

    if G.shop and not G.shop.alignment.offset.py then
        G.shop.alignment.offset.py = G.shop.alignment.offset.y
        G.shop.alignment.offset.y = G.ROOM.T.y + 29
    end
    if G.blind_select and not G.blind_select.alignment.offset.py then
        G.blind_select.alignment.offset.py = G.blind_select.alignment.offset.y
        G.blind_select.alignment.offset.y = G.ROOM.T.y + 39
    end
    if G.round_eval and not G.round_eval.alignment.offset.py then
        G.round_eval.alignment.offset.py = G.round_eval.alignment.offset.y
        G.round_eval.alignment.offset.y = G.ROOM.T.y + 29
    end


    G.E_MANAGER:add_event(Event({
        delay = 5.0,
        func = function()
            G.GAME.RemovePseudoOpen = true
            return true
        end,
    }))
end
