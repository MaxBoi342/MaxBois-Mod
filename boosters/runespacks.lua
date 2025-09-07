SMODS.Booster {
    key = 'rune',
    loc_txt = {
        name = "Rune Pack",
        text = {
            "Select one of two runes to be used instantly."
        },
        group_name = "k_maxboism_rune_normal1"
    },
    config = { extra = 2, choose = 1 },
    cost = 8,
    atlas = "CustomBoosters",
    pos = { x = 0, y = 0 },
    kind = 'Rune',
    group_key = "k_maxboism_rune_normal1",
    select_card = "consumeables",
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
            set = "rune",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false
        }
    end,
    weight = 1.2,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("1426b1"))
        ease_background_colour({ new_colour = HEX('1426b1'), special_colour = HEX("1a4d6c"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}