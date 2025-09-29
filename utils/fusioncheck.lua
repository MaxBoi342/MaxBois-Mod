

local function findAll(multiboxes, reqs)
    local positions = {}
    local used = {}  

    for _, item in ipairs(reqs) do
        local foundPos = nil
        for i, v in ipairs(multiboxes) do
            if v[1] == item and not used[i] then
                foundPos = i
                used[i] = true
                break
            end
        end
        if not foundPos then
            return nil 
        end
        table.insert(positions, foundPos)
    end

    return positions
end

function MaxBoiSM.fusionCheck(multiboxes)

    for _, fusion in ipairs(MaxBoiSM.fusionTable) do
    local needed, result = fusion[1], fusion[2]
    local positions = findAll(multiboxes, needed)
    if positions then
        table.sort(positions, function(a, b) return a > b end)
        for _, pos in ipairs(positions) do
            table.remove(multiboxes, pos)
        end
        SMODS.add_card({key = "j_maxboism_photochad"})
    end
end
end