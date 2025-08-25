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