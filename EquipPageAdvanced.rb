#===============================================================================
# Mobius' Equip Page Advanced (Add-on)
# Author: Mobius XVI
# Version: 1.0
# Date: 4 SEP 2021
#===============================================================================
#
# Instructions:
#
#   Place this script below the Mobius Equip Page script but above main.
#
#   Visit the forums for detailed instructions and license terms:
#   https://forums.rpgmakerweb.com/index.php?threads/mobiuss-better-equip-page.16408/
#
#==============================================================================
# CUSTOMIZATION START
#==============================================================================
module Mobius
  module EquipPage
    #--------------------------------------------------------------------------
    # * Module constants
    #--------------------------------------------------------------------------
      ELEMENT_ATK = 1 # DON'T TOUCH
      ELEMENT_DEF = 2 # DON'T TOUCH
      STATUS_ATK  = 3 # DON'T TOUCH
      STATUS_DEF  = 4 # DON'T TOUCH
      ICONS_TO_SHOW = [
        # ROW 1
        [
          # ICON 1
          {
            :MEP_TYPE => ELEMENT_ATK,
            :MEP_ID => 1,
          },
          # ICON 2
          {
            :MEP_TYPE => ELEMENT_DEF,
            :MEP_ID => 1,
          },
          # ICON 3
          {
            :MEP_TYPE => ELEMENT_ATK,
            :MEP_ID => 2,
          },
          # ICON 4
          {
            :MEP_TYPE => ELEMENT_DEF,
            :MEP_ID => 2,
          },
          # ICON 5
          {
            :MEP_TYPE => STATUS_ATK,
            :MEP_ID => 3,
          },
          # ICON 6
          {
            :MEP_TYPE => STATUS_DEF,
            :MEP_ID => 3,
          },
        ], 
        # ROW 2
        [
          # ICON 1
          {
            :MEP_TYPE => ELEMENT_ATK,
            :MEP_ID => 3,
          },
          # ICON 2
          {
            :MEP_TYPE => ELEMENT_DEF,
            :MEP_ID => 3,
          },
          # ICON 3
          {
            :MEP_TYPE => ELEMENT_ATK,
            :MEP_ID => 4,
          },
          # ICON 4
          {
            :MEP_TYPE => ELEMENT_DEF,
            :MEP_ID => 4,
          },
          # ICON 5
          {
            :MEP_TYPE => STATUS_ATK,
            :MEP_ID => 7,
          },
          # ICON 6
          {
            :MEP_TYPE => STATUS_DEF,
            :MEP_ID => 7,
          },
        ],
        # ROW 3
        [
          # ICON 1
          {
            :MEP_TYPE => STATUS_ATK,
            :MEP_ID => 4,
          },
          # ICON 2
          {
            :MEP_TYPE => STATUS_ATK,
            :MEP_ID => 5,
          },
        ],
        # ROW 4
        [
          # ICON 1
          {
            :MEP_TYPE => STATUS_DEF,
            :MEP_ID => 4,
          },
          # ICON 2
          {
            :MEP_TYPE => STATUS_DEF,
            :MEP_ID => 5,
          },
        ],
      ]
  end
end
#==============================================================================
# CUSTOMIZATION END -- DON'T EDIT BELOW THIS LINE!!!
#==============================================================================

#==============================================================================
# ** Window_EquipLeft
#------------------------------------------------------------------------------
#  This window displays actor parameter changes on the equipment screen.
#==============================================================================

class Window_EquipLeft < Window_Base
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_name(@actor, 4, 0)
    draw_parameters
    draw_icons
  end
  #--------------------------------------------------------------------------
  # * Draw Icons
  #--------------------------------------------------------------------------
  def draw_icons
    for i in 0...4
      draw_icon_set(i, 4, 258 + (i * 34))
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Icon Set - Draws an icon set (i.e. a row of icons)
  #     row : a row ID
  #     x   : draw spot x-coordinate
  #     y   : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_icon_set(row, x, y)
    show_list = Mobius::EquipPage::ICONS_TO_SHOW[row]
    for i in 0...show_list.length
      set_id = show_list[i][:MEP_ID]
      set_type = show_list[i][:MEP_TYPE]
      if @stats != nil
        actor_set = @stats[set_type]
      else
        case set_type
        when 1
          actor_set = @actor.element_set
        when 2
          actor_set = @actor.defense_element_set
        when 3
          actor_set = @actor.plus_state_set
        when 4
          actor_set = @actor.defense_state_set
        end
      end
      enabled = actor_set.include?(set_id)
      case set_type
      when 1..2
        name = $data_system.elements[set_id]
      when 3..4
        name = $data_states[set_id].name
      end
      case set_type
      when 1,3
        type = 'attack'
      when 2,4
        type = 'defense'
      end
      filename = name + '-' + type + '-' + (enabled ? 'enabled' : 'disabled')
      draw_x = x + (30 * i)
      draw_icon(filename, draw_x, y)
    end
  end
end #class end