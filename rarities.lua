SMODS.Rarity {
    key = "friendendary",
    pools = {
        ["Joker"] = true
    },
    default_weight = 0,
    badge_colour = HEX('270048'),
    loc_txt = {
        name = "Friendendary"
    },
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Rarity {
    key = "merged",
    pools = {
        ["Joker"] = true
    },
    default_weight = 0,
    badge_colour = HEX('B5179E'),
    loc_txt = {
        name = "Merged"
    },
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Rarity {
    key = "fusion",
    pools = {
        ["Joker"] = true
    },
    default_weight = 0,
    badge_colour = HEX('6E1F1B'),
    loc_txt = {
        name = "Fusion"
    },
    get_weight = function(self, weight, object_type)
        return weight
    end,
}