#===============================================================================
# Mobius' Equip Page
# Author: Mobius XVI
# Version: 2.0
# Date: 14 AUG 2021
#===============================================================================
#
# Instructions:
#
#   Place this script below all the default scripts but above main.
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
      ELEMENTS_TO_SHOW = [1,2,3,4,5,6]    # IDs of element types to show
			STATES_TO_SHOW = [3,7,4,5]          # IDs of status types to show
  end
end
#==============================================================================
# CUSTOMIZATION END -- DON'T EDIT BELOW THIS LINE!!!
#==============================================================================

#==============================================================================
# ** Scene_Equip
#------------------------------------------------------------------------------
#  This class performs equipment screen processing.
#==============================================================================

class Scene_Equip
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # Set item window to visible
    @item_window1.visible = (@right_window.index == 0)
    @item_window2.visible = (@right_window.index == 1)
    @item_window3.visible = (@right_window.index == 2)
    @item_window4.visible = (@right_window.index == 3)
    @item_window5.visible = (@right_window.index == 4)
    # Get currently equipped item
    item1 = @right_window.item
    # Set current item window to @item_window
    case @right_window.index
    when 0
      @item_window = @item_window1
    when 1
      @item_window = @item_window2
    when 2
      @item_window = @item_window3
    when 3
      @item_window = @item_window4
    when 4
      @item_window = @item_window5
    end
    # If right window is active
    if @right_window.active
      # Erase parameters for after equipment change
			@left_window.set_new_stats(nil)
    end
    # If item window is active
    if @item_window.active
      # Get currently selected item
      item2 = @item_window.item
      # Change equipment
      last_hp = @actor.hp
      last_sp = @actor.sp
      @actor.equip(@right_window.index, item2 == nil ? 0 : item2.id)
      # Get stats for after equipment change
			stats = []
			stats.push(@actor.equip_parameters)
			stats.push(@actor.element_set)
			stats.push(@actor.defense_element_set)
			stats.push(@actor.plus_state_set)
			stats.push(@actor.defense_state_set)
      # Return equipment
      @actor.equip(@right_window.index, item1 == nil ? 0 : item1.id)
      @actor.hp = last_hp
      @actor.sp = last_sp
      # Draw in left window
			@left_window.set_new_stats(stats)
    end
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This class is for all in-game windows.
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Draw Icon
  #     icon_name : filename of the icon
  #     x         : draw spot x-coordinate
  #     y         : draw spot y-coordinate
  #--------------------------------------------------------------------------
  def draw_icon(icon_name, x, y)
		# Load icon
		begin
			bitmap = RPG::Cache.icon(icon_name)
		rescue
			bitmap = Bitmap.new(24,24)
			bitmap.fill_rect(bitmap.rect, Color.new(255,0,255)) 
		end
		# Copy icon to window
    src_rect = Rect.new(0, 0, 24, 24)
    self.contents.blt(x, y, bitmap, src_rect)
  end
end #class end

#==============================================================================
# ** Window_EquipItem
#------------------------------------------------------------------------------
#  This window displays choices when opting to change equipment on the
#  equipment screen.
#==============================================================================

class Window_EquipItem < Window_Selectable
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor      : actor
  #     equip_type : equip region (0-3)
  #--------------------------------------------------------------------------
  def initialize(actor, equip_type)
    super(272, 256, 368, 224)
    @actor = actor
    @equip_type = equip_type
    @column_max = 1
    refresh
    self.active = false
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : item number
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    x = 4
    y = index * 32
    case item
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
		draw_icon(item.icon_name, x, y + 4)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, ":", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
end #class end

#==============================================================================
# ** Window_EquipLeft
#------------------------------------------------------------------------------
#  This window displays actor parameter changes on the equipment screen.
#==============================================================================

class Window_EquipLeft < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 64, 272, 416)
    self.contents = Bitmap.new(width - 32, height - 32)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_actor_name(@actor, 4, 0)
		draw_parameters
		draw_elements
    draw_states    
  end
  #--------------------------------------------------------------------------
  # * Set parameters after changing equipment
  #     stats  : array of arrays containing
  #       params          : array of atk, pdef, mdef, etc
  #       atk_element_set : array of element ids
	#       def_element_set : array of element ids
  #       atk_state_set   : array of state ids
	#       def_state_set   : array of state ids
  #--------------------------------------------------------------------------
  def set_new_stats(stats)
    if @stats != stats
				@stats = stats
				refresh
    end
  end
	#--------------------------------------------------------------------------
  # * Draw Parameters
  #--------------------------------------------------------------------------
  def draw_parameters
		draw_new = false
		if @stats != nil
			params = @stats[0]
			draw_new = true
		end
		for i in 0..6
			draw_y = 32 + (32 * i)
			draw_actor_parameter(@actor, 4, draw_y, i)
			if draw_new
				old_param = @actor.parameter_by_type(i)
				new_param = params[i]
				self.contents.font.color = system_color
				self.contents.draw_text(160, draw_y, 40, 32, "->", 1)
				self.contents.font.color = color_choose(old_param, new_param)
				self.contents.draw_text(200, draw_y, 36, 32, new_param.to_s, 2)
			end
		end
  end
	#------------------------------------------------------------------------------
	# * Color Choose - Decide text color based on whether the stat improves
	#------------------------------------------------------------------------------
  def color_choose(old_stat, new_stat)
    compare = (old_stat <=> new_stat)
    case compare
    when -1 #new is better
      Color.new(0, 255, 0, 255) #Return green color
    when 0 #old=new
      normal_color #Return white color
    when 1 #old is better
      Color.new(255, 0, 0, 255) #Return red color
    end
  end
	#--------------------------------------------------------------------------
  # * Draw Elements
  #--------------------------------------------------------------------------
  def draw_elements
		if @stats != nil
			atk_element_set = @stats[1]
			def_element_set = @stats[2]
		else
			atk_element_set = @actor.element_set
			def_element_set = @actor.defense_element_set
		end
		draw_icon_set(atk_element_set, 4, 258, 'attack', :MobiusEquipPageElement)
		draw_icon_set(def_element_set, 4, 292, 'defense', :MobiusEquipPageElement)
  end
	#--------------------------------------------------------------------------
  # * Draw States
  #--------------------------------------------------------------------------
  def draw_states
		if @stats != nil
			plus_state_set = @stats[3]
			defense_state_set = @stats[4]
		else
			plus_state_set = @actor.plus_state_set
			defense_state_set = @actor.defense_state_set
		end
		draw_icon_set(plus_state_set, 4, 326, 'attack', :MobiusEquipPageState)
		draw_icon_set(defense_state_set, 4, 358, 'defense', :MobiusEquipPageState)
  end
	#--------------------------------------------------------------------------
  # * Draw Icon Set - Draws an icon set for a given actor set
  #     actor_set : an element or status set for a given actor; e.g. [2,5,6]
  #     x         : draw spot x-coordinate
  #     y         : draw spot y-coordinate
	#     type      : 'attack' OR 'defense'
	#     kind      : :MobiusEquipPageElement OR :MobiusEquipPageState
  #--------------------------------------------------------------------------
  def draw_icon_set(actor_set, x, y, type, kind)
		if kind == :MobiusEquipPageElement
			show_list = Mobius::EquipPage::ELEMENTS_TO_SHOW
		else
			show_list = Mobius::EquipPage::STATES_TO_SHOW
		end
		for i in 0...show_list.length
			set_id = show_list[i]
			enabled = actor_set.include?(set_id)
			if kind == :MobiusEquipPageElement
				name = $data_system.elements[set_id]
			else
				name = $data_states[set_id].name
			end
			filename = name + '-' + type + '-' + (enabled ? 'enabled' : 'disabled')
			draw_x = x + (30 * i)
			draw_icon(filename, draw_x, y)
		end
  end
end #class end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
	#--------------------------------------------------------------------------
  # * Get a parameter by its type
  #--------------------------------------------------------------------------
  def parameter_by_type(type)
    case type
    when 0
      return self.atk
    when 1
			return self.pdef
    when 2
      return self.mdef
    when 3
      return self.str
    when 4
      return self.dex
    when 5
      return self.agi
    when 6
      return self.int
    end
  end
	#--------------------------------------------------------------------------
  # * Get an array of an actor's parameters
  #--------------------------------------------------------------------------
  def equip_parameters
    return [
			self.atk,
      self.pdef,
      self.mdef,
      self.str,
      self.dex,
      self.agi,
      self.int
		]
  end
  #--------------------------------------------------------------------------
  # * Get Normal Defense Elements
  #--------------------------------------------------------------------------
  def defense_element_set
    result = []
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      armor = $data_armors[i]
      if armor != nil 
        result |= armor.guard_element_set
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Get Normal State Defense 
  #--------------------------------------------------------------------------
  def defense_state_set
    result = []
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      armor = $data_armors[i]
      if armor != nil 
        result |= armor.guard_state_set
      end
    end
    return result
  end
end #class end
