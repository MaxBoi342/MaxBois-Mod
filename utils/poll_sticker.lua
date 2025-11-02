--key: the seed for generation
--mod: chance to apply the sticker
--no_pin: boolean to ignore pinned because PINNED IS A STICKER #JUSTICEFORPINNED
--guaranteed: boolean to guarantee a sticker actually gets applied.
--options: a list of keys (default is SMODS.Stickers.obj_buffer (all stickers known to SMODS)) or a string indicating a preset
--rates: modify the rates of the stickers for this specific poll. (default uses the self.rate for each sticker (except pinned, which gets the rate of 1)) (requires options to exist)
--card: card (used to perform card specific compat)
function MaxBoiSM.poll_sticker(args)
    local key = args.key or 'sticker_generic'
    local type_key = args.type_key or key.."type"..G.GAME.round_resets.ante
    local mod = args.mod or 1
    local no_pin = args.no_pin or false
    local guaranteed = args.guaranteed or false
    local options
    local rates
    local card = args.card or nil
    key = key .. G.GAME.round_resets.ante
    
    if type(args.options) == 'string' then
        if args.options == "vanilla" then
            options = { 'eternal', 'perishable', 'rental', 'pinned' }
        elseif args.options == "black" then
            options = { 'eternal' }
        elseif args.options == "orange" then
            options = { 'eternal', 'perishable' }
        elseif args.options == "gold" then
            options = { 'eternal', 'perishable', 'rental' }
        end
    elseif type(args.options) == 'table' then
        options = args.options
    else
        options = SMODS.Sticker.obj_buffer
    end

    if args.rates then
        assert(#args.rates == #options, "poll_sticker options and rates length mismatch, every sticker needs a rate provided")
        rates = args.rates
    end

    local available_stickers = {}
    local total_weight = 0
    

    for _, v in ipairs(options) do
        local sticker_option = {}
        local sticker
        if type(v) == 'string' then
            assert(SMODS.Stickers[v], ("Could not find sticker \"%s\"."):format(v))
            sticker = SMODS.Stickers[v]
        elseif type(v) == 'table' then
            assert(SMODS.Stickers[v.key], ("Could not find sticker \"%s\"."):format(v.key))
            sticker = SMODS.Stickers[v.key]
        end


        if not (v == 'pinned' and no_pin) then
            if not card or MaxBoiSM.can_apply_sticker(sticker, card) then
                if rates then
                    sticker_option = { name = v, weight = rates[_] }
                else
                    sticker_option = { name = v, weight = v ~= 'pinned' and sticker.rate * 10 or 1 }
                end
                if sticker_option.weight > 0 then
                    table.insert(available_stickers, sticker_option)
                    total_weight = total_weight + sticker_option.weight
                end
                
            end
        end
    end
    total_weight = total_weight + (total_weight / 40 * 60)

    local type_weight = 0 -- if sticker ever get rate modifiers, implement it here
    for _,v in ipairs(available_stickers) do
        type_weight = type_weight + v.weight
    end
 
---@diagnostic disable-next-line: ambiguity-1
    local sticker_poll = pseudorandom(pseudoseed(key or 'sticker_generic'..G.GAME.round_resets.ante ))
    if sticker_poll > 1 - (type_weight*mod / total_weight) or guaranteed then
        local sticker_type_poll = pseudorandom(pseudoseed(type_key))
        local weight_i = 0 --and roll
        for _, v in ipairs(available_stickers) do
            weight_i = weight_i + v.weight
            if sticker_type_poll > 1 - (weight_i) / type_weight then
               return v.name
            end
        end
    end
    return nil
end

function MaxBoiSM.can_apply_sticker(sticker, card)
    if type(sticker.should_apply) == 'function' then
        return sticker:should_apply(card, card.config.center, nil, true)
    end
    local center = card.config.center
    if (center[sticker.key .. '_compat'] or (center[sticker.key .. '_compat'] == nil and ((sticker.default_compat and not sticker.compat_exceptions[center.key]) or -- default yes with no exception
            (not sticker.default_compat and sticker.compat_exceptions[center.key])))) then                                                                          --default no with exceptions
        if not card.ability[sticker.key] then
            if card.pinned and sticker.key == 'pinned' then
                --#JUSTICEFORPINNED
            elseif not (card.ability['perishable'] and sticker.key == 'eternal' or card.ability['eternal'] and sticker.key == 'perishable') then --vanilla sticker exclusivity check, idk if theres a proper way to do it
                return true
            end
        end
    end
    return false
end