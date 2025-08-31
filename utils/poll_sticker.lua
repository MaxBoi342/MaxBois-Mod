-- WE GETTING INSPIRED BY POLL_EDITION WITH THIS ONE
--_key: the seed for generation (presets: black, orange, gold, vanilla)
--_mod: chance to apply the sticker
--_no_pin: boolean to ignore pinned because PINNED IS A STICKER #JUSTICEFORPINNED
--_guaranteed: boolean to guarantee a sticker actually gets applied.
--_options: a list of keys (default is SMODS.Stickers.obj_buffer (all stickers known to SMODS))
--_rates: modify the rates of the stickers for this specific poll. (default uses the self.rate for each sticker (except pinned, which gets the rate of 1)) (requires options to exist)
--_card: card (used to perform card specific compat)
-- everything is optional lol

function poll_sticker(_key, _mod, _no_pin, _guaranteed, _options, _rates, _card)
    local _modifier = 1
    local sticker_poll = pseudorandom(pseudoseed(_key or 'sticker_generic')) -- Generate the poll value
    local available_stickers = {}
    local rates_flag = false

    if not _options then
        --VANILLA PRESETS--
        if _key == "vanilla" then
            _options = { 'eternal', 'perishable', 'rental', 'pinned' }
        elseif _key == "black" then
            _options = { 'eternal' }
        elseif _key == "orange" then
            _options = { 'eternal', 'perishable' }
        elseif _key == "gold" then
            _options = { 'eternal', 'perishable', 'rental' }
        else
            _options = SMODS.Sticker.obj_buffer
        end
    elseif _rates then
        assert(#_rates == #_options,
            "poll_sticker options and rates length mismatch, every sticker needs a rate provided")
        rates_flag = true
    end

    for _, v in ipairs(_options) do
        local sticker_option = {}
        local sticker = SMODS.Stickers[v]

        if not (v == 'pinned' and _no_pin) then
            if _card then
                local center = _card.config.center
                if (center[sticker.key .. '_compat'] or (center[sticker.key .. '_compat'] == nil and ((sticker.default_compat and not sticker.compat_exceptions[center.key]) or -- default yes with no exception
                        (not sticker.default_compat and sticker.compat_exceptions[center.key])))) then --default no with exceptions
                    
                    if not _card.ability[v] then --dont apply what you already have
                        if _card.pinned and v == 'pinned' then

                        elseif not (_card.ability['perishable'] and v == 'eternal' or _card.ability['eternal'] and v == 'perishable') then --vanilla exclusivity check, idk if theres a proper way to do it
                            if rates_flag then
                                sticker_option = { name = v, weight = _rates[_] }
                            else
                                sticker_option = { name = v, weight = v ~= 'pinned' and sticker.rate * 10 or 1 }
                            end
                            table.insert(available_stickers, sticker_option)
                        end
                    end
                end
            else --if no card, just do generic polling
                if rates_flag then
                    sticker_option = { name = v, weight = _rates[_] }
                else
                    sticker_option = { name = v, weight = v ~= 'pinned' and sticker.rate * 10 or 1 }
                end
                table.insert(available_stickers, sticker_option)
            end
        end
    end

    local total_weight = 0 --weight calculation (thank you poll_edition for allowing me to ignore math)
    for _, v in ipairs(available_stickers) do
        total_weight = total_weight + (v.weight)
    end

    if not _guaranteed then
        _modifier = _mod or 1
        total_weight = total_weight + (total_weight / 3 * 2) -- Find total weight with base_card_rate as ~66%
    end

    local weight_i = 0 --and roll
    for _, v in ipairs(available_stickers) do
        weight_i = weight_i + v.weight * _modifier
        if sticker_poll > 1 - (weight_i) / total_weight then
            return v.name
        end
    end

    return nil
end
