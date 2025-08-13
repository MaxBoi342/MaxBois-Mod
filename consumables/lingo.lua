SMODS.Sound {
    key = "lingosolve",
    path = "lingosolve.ogg"
}

SMODS.Consumable {
    key = 'lingo',
    set = 'game',
    pos = { x = 0, y = 0 },
    config = { extra = {
        hand_size_value = 1
    } },
    cost = 5,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    --  atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.FUNCS.overlay_menu({ definition = create_UIBox_lingo(), pause = true })
                return true
            end,
        }))
    end,
    can_use = function(self, card)
        return true
    end,
}

function create_UIBox_lingo()
    local t = create_UIBox_generic_options({
        no_back = true,
        colour = HEX('c8640f'),
        outline_colour = HEX('8c470b'),
        contents = {
            {
                n = G.UIT.R,
                nodes = {
                    create_lingo_puzzle()
                },
                config = { minw = 1, minh = 1, colour = G.C.RED, padding = 0.15, align = "cm" },
            },
            {
                n = G.UIT.R,
                config = { align = "cm" },
                nodes = {
                    create_text_input({
                        colour = HEX('8c470b'),
                        hooked_colour = darken(HEX('8c470b'), 0.3),
                        w = 4.5,
                        h = 1,
                        max_length = 100,
                        prompt_text = 'ENTER ANSWER',
                        ref_table = MaxBoiSM,
                        ref_value = "ENTERED_LINGO_WORD",
                        keyboard_offset = 1,
                        all_caps = true
                    })
                },
            },
            {
                n = G.UIT.R,
                config = { align = "cm" },
                nodes = {
                    UIBox_button({
                        colour = G.C.RED,
                        button = "lingo_check",
                        label = { 'GUESS' },
                        minw = 4.5,
                        focus_args = { snap_to = true },
                    }),
                },
            }
        }
    }
    )
    return t
end

G.FUNCS.lingo_check = function()
    if MaxBoiSM.CUR_LINGO_ANSWER == MaxBoiSM.ENTERED_LINGO_WORD then
        play_sound("maxboism_lingosolve")
        G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    ease_dollars(20, true)
                    return true
                end
            }))
            MaxBoiSM.ENTERED_LINGO_WORD = ''
        G.FUNCS.exit_overlay_menu()
    else
        G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    ease_dollars(-math.min(G.GAME.dollars, 2), true)
                    return true
                end
            }))
            MaxBoiSM.ENTERED_LINGO_WORD = ''
        G.FUNCS.exit_overlay_menu()
    end
end

function puzzleToTable(TT, MT, BT, TC, MC, BC, A)
    local puzzleFormat = {
        topText = TT,
        middleText = MT,
        bottomText = BT,
        topColor = TC,
        middleColor =  MC,
        bottomColor =  BC,
        answer = A
    }
    return puzzleFormat
end

function create_lingo_puzzle()

    local puzzleDatabase = {
        puzzleToTable('HIGH', 'HI', 'HELLO', 'WH', 'WH', 'WH', 'HI'),
        puzzleToTable('', 'EVIL', 'DIE', 'XX', 'BK', 'BK', 'LIVE'),
        puzzleToTable('', '', 'CLOCKWISE', 'XX', 'XX', 'BK', 'COUNTERCLOCKWISE'),
    }

    local selectedPuzzle = pseudorandom_element(puzzleDatabase, 'Linger')
    
    MaxBoiSM.CUR_LINGO_ANSWER = selectedPuzzle.answer
    local t = {
        n = G.UIT.C,
        nodes = {
            {
                n = G.UIT.R,
                config = { minw = 2.5, minh = 2.5, colour = MaxBoiSM.COLORS[selectedPuzzle.topColor], padding = 0.15, align = "cm" },
                nodes = {
                    {n = G.UIT.T, config = { colour = selectedPuzzle.topColor ~= 'BK' and G.C.BLACK or HEX('FFFFFF'), padding = 0.15, align = "cm", scale = 1.0, text = selectedPuzzle.topText or '' }},
                }

            },
            {
                n = G.UIT.R,
                config = { minw = 2.5, minh = 2.5, colour = MaxBoiSM.COLORS[selectedPuzzle.middleColor], padding = 0.15, align = "cm" },
                nodes = {
                    {n = G.UIT.T, config = { colour = selectedPuzzle.middleColor ~= 'BK' and G.C.BLACK or HEX('FFFFFF'), padding = 0.15, align = "cm", scale = 1.0, text = selectedPuzzle.middleText or '' }},
                }

            },
            {
                n = G.UIT.R,
                config = { minw = 2.5, minh = 2.5, colour = MaxBoiSM.COLORS[selectedPuzzle.bottomColor], padding = 0.15, align = "cm" },
                nodes = {
                    {n = G.UIT.T, config = { colour = selectedPuzzle.bottomColor ~= 'BK' and G.C.BLACK or HEX('FFFFFF'), padding = 0.15, align = "cm", scale = 1.0, text = selectedPuzzle.bottomText or '' }},
                }

            },
        },
        config = { minw = 2, minh = 6, colour = G.C.RED, padding = 0.15, align = "cm" },
    }
    return t
end
