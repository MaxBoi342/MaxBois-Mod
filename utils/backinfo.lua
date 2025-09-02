local card_hover_ref = Card.hover
function Card:hover()
    card_hover_ref(self)
    if self.facing == 'back' and (not self.states.drag.is or G.CONTROLLER.HID.touch) and not self.no_ui then
        self.ability_UIBox_table = self:generate_UIBox_ability_table()
        self.config.h_popup = G.UIDEF.card_h_popup(self)
        self.config.h_popup_config = self:align_h_popup()

        Node.hover(self)
    end
end

  G.FUNCS.show_center_infotip = function(e)
    if e.config.ref_table then 
      e.children.info = UIBox{
        definition = {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR, padding = 0.02}, nodes=e.config.ref_table},
        config = {offset = {x=0,y=-0.5}, align = 'cm', parent = e}
      }
      e.children.info:align_to_major()
      e.config.ref_table = nil
    end
  end