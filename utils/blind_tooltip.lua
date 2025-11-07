local function stringSplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

-- Credit to Victin!

MaxBoiSM.create_UIBox_blind_popup_with_icon = function(blind_key, remove_reward)
    local blind = G.P_BLINDS[blind_key]
    local original_UIBox = create_UIBox_blind_popup(blind, true).nodes
    if remove_reward then
        table.remove(original_UIBox[2].nodes[1].nodes, 3)
    end -- Removes row listing money reward

    local blind_icon = {}
    blind_icon.animation = AnimatedSprite(0, 0, 1.4, 1.4, G.ANIMATION_ATLAS[blind.atlas or 'blind_chips'], blind.pos)
    blind_icon.animation:define_draw_steps({{
        shader = 'dissolve',
        shadow_height = 0.05
    }, {
        shader = 'dissolve'
    }})

    local icon_holder = {
        n = G.UIT.R,
        config = {
            align = "cm",
            minh = 1.50
        },
        nodes = {{
            n = G.UIT.O,
            config = {
                object = blind_icon.animation
            }
        }}
    }
    table.insert(original_UIBox, 2, icon_holder)
    return original_UIBox
end

local info_tip_from_rows_ref = info_tip_from_rows
function info_tip_from_rows(desc_nodes, name)
    if string.find(name, "maxboism_blindindicator") then
        local blind = stringSplit(name, "_")[3]
        return {
           n=G.UIT.R,
           config={
               align = "cm",
               colour = G.C.CLEAR,
               r = 0.1,         
           },
           nodes = MaxBoiSM.create_UIBox_blind_popup_with_icon('bl_maxboism_' .. blind),
        }
    else
        return info_tip_from_rows_ref(desc_nodes, name)
    end
end
