---@diagnostic disable: unused-local, redefined-local, missing-fields, inject-field

--DO NOTE that group_key with name/kind are used for the locatization file for text information
function Card:pseudo_open(args)
    --assert everyhing is provided (look into SMODS booster packs and base game booster pack code how some of these need to look like)
    assert(type(args.choose) == 'number', "Provide how many cards are picked with 'choose = x'")
    assert(type(args.extra) == 'number', "Provide how many cards are chosen from with 'extra = x'")
    assert(type(args.create_card) == 'function',
        "please provide a card creating function with create_card = function(self, card, i)")
    assert(type(args.background_color) == 'table' and #args.background_color == 2,
        "Provide colors with a table with 2 entries with 'background_color = {x,y}'")
    assert(type(args.draw_hand) == 'boolean',
        "Please provide if the hand should be drawn or not with 'draw_hand == true or false'")

    local functiontoBe
    if args.sparkles and assert(type(args.sparkles) == 'function', "args.sparkles must be a function") then
        functiontoBe = args.sparkles
    else
        functiontoBe = function() --lol

        end
    end
    self.config.center = { --the slightly jank option, pretend that something is a booster pack by injecting booster pack properties
        group_key = "k_maxboism_what",
        name = "???",
        kind = '???',
        key = 'p_arcana_normal_1', --this should be fine this is just to trick SMODS into letting this run, it doesn't actually count as opening an arcana pack
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

    draw_card(self.area, G.play, 1, 'up', true, self, nil, true) -- draw the card to the middle
    if G.hand and #G.hand.cards > 0 then --hide playing cards if opened in middle of round
        G.FUNCS.draw_from_hand_to_deck()
        delay(0.65)
    end

    self:open() -- open the card :clueless:


    --fix the UI back
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

    local event --god bless smods documentation for this loop I need to exist.
    event = Event {
        blockable = false,
        blocking = false,
        pause_force = true,
        no_delete = true,
        trigger = "after",
        delay = 0.5,
        timer = "UPTIME",
        func = function()
            if G.STATE == nil then --fix state machine obliterating itself
                if G.shop then
                    G.STATE = G.STATES.SHOP
                elseif G.blind_select then
                    G.STATE = G.STATES.BLIND_SELECT
                elseif G.round_eval then
                    G.STATE = G.STATES.ROUND_EVAL
                else
                    G.STATE = G.STATES.SELECTING_HAND
                end
                G.play:remove_card(G.play.cards[1]) --fix G.play issue
                return true
            else
                event.start_timer = false
            end
        end
    }
    G.E_MANAGER:add_event(event)
end
