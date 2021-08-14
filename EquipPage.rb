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
      @left_window.set_new_parameters(nil, nil, nil, nil, nil, nil, nil)
      @left_window.set_elements(nil, nil)
      @left_window.set_states(nil, nil)
    end
    # If item window is active
    if @item_window.active
      # Get currently selected item
      item2 = @item_window.item
      # Change equipment
      last_hp = @actor.hp
      last_sp = @actor.sp
      @actor.equip(@right_window.index, item2 == nil ? 0 : item2.id)
      # Get parameters for after equipment change
      new_atk = @actor.atk
      new_pdef = @actor.pdef
      new_mdef = @actor.mdef
      new_str = @actor.str
      new_dex = @actor.dex
      new_agi = @actor.agi
      new_int = @actor.int
      # Get element_set for after equipment change
      atk_element_set = @actor.element_set
      def_element_set = @actor.defense_element_set
      # Get state_set for after equipment change
      plus_state_set = @actor.plus_state_set
      def_state_set = @actor.defense_state_set
      # Return equipment
      @actor.equip(@right_window.index, item1 == nil ? 0 : item1.id)
      @actor.hp = last_hp
      @actor.sp = last_sp
      # Draw in left window
      @left_window.set_new_parameters(new_atk, new_pdef, new_mdef, new_str, \
      new_dex, new_agi, new_int)
      @left_window.set_elements(atk_element_set, def_element_set)
      @left_window.set_states(plus_state_set, def_state_set)
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
  #     icon_name : filename of the icon ("String")
  #     x         : draw spot x-coordinate
  #     y         : draw spot y-coordinate
  #     MOBIUS ADDED
  #--------------------------------------------------------------------------
  def draw_icon(icon_name, x, y)
    bitmap = RPG::Cache.icon(icon_name)
    src_rect = Rect.new(0, 0, 24, 24)
    self.contents.blt(x, y, bitmap, src_rect)
  end
  
  #--------------------------------------------------------------------------
  # * Draw Attack Elements - Draws the active attack elements for a given actor
  #     element_set     : the element set for a given actor
  #     x               : draw spot x-coordinate
  #     y               : draw spot y-coordinate
  #     MOBIUS ADDED
  #--------------------------------------------------------------------------
  def draw_attack_elements(element_set, x, y)
      #Draw fire if active
      if element_set.include?(1) 
        draw_icon("Fire", x, y)
      else
        draw_icon("Fire 2", x, y)
      end
      #Draw ice if active
      if element_set.include?(2) 
        draw_icon("Ice", x + 30, y)
      else
        draw_icon("Ice 2", x + 30, y)
      end
      #Draw lightning if active
      if element_set.include?(3) 
        draw_icon("Lightning", x + 60, y)
      else
        draw_icon("Lightning 2", x + 60, y)
      end
      #Draw water if active
      if element_set.include?(4) 
        draw_icon("Water", x + 90, y)
      else
        draw_icon("Water 2", x + 90, y)
      end
      #Draw earth if active
      if element_set.include?(5) 
        draw_icon("Earth", x + 120, y)
      else
        draw_icon("Earth 2", x + 120, y)
      end
      #Draw wind if active
      if element_set.include?(6) 
        draw_icon("Wind", x + 150, y)
      else
        draw_icon("Wind 2", x + 150, y)
      end
  end
    
  #--------------------------------------------------------------------------
  # * Draw Defense Elements - Draws the active defense elements for a given actor
  #     defense_element_set     : the defense element set for a given actor
  #     x                       : draw spot x-coordinate
  #     y                       : draw spot y-coordinate
  #     MOBIUS ADDED
  #--------------------------------------------------------------------------
  def draw_defense_elements(defense_element_set, x, y)
      #Draw fire if active
      if defense_element_set.include?(1) 
        draw_icon("Fire Def", x, y)
      else
        draw_icon("Fire Def 2", x, y)
      end
      #Draw ice if active
      if defense_element_set.include?(2) 
        draw_icon("Ice Def", x + 30, y)
      else
        draw_icon("Ice Def 2", x + 30, y)
      end
      #Draw lightning if active
      if defense_element_set.include?(3) 
        draw_icon("Lightning Def", x + 60, y)
      else
        draw_icon("Lightning Def 2", x + 60, y)
      end
      #Draw water if active
      if defense_element_set.include?(4) 
        draw_icon("Water Def", x + 90, y)
      else
        draw_icon("Water Def 2", x + 90, y)
      end
      #Draw earth if active
      if defense_element_set.include?(5) 
        draw_icon("Earth Def", x + 120, y)
      else
        draw_icon("Earth Def 2", x + 120, y)
      end
      #Draw wind if active
      if defense_element_set.include?(6) 
        draw_icon("Wind Def", x + 150, y)
      else
        draw_icon("Wind Def 2", x + 150, y)
      end
    end
    
  #--------------------------------------------------------------------------
  # * Draw Plus States - Draws states the a weapon adds for a given actor
  #     state_set     : the plus state set for a given actor
  #     x             : draw spot x-coordinate
  #     y             : draw spot y-coordinate
  #     MOBIUS ADDED
  #--------------------------------------------------------------------------
  def draw_plus_states(state_set, x, y)
    if state_set == []
      self.contents.font.color = system_color
      self.contents.draw_text(x, y, 240, 32, "Inflicts: ")
    elsif state_set.size == 1
      state = $data_states[state_set[0]]
      self.contents.font.color = system_color
      self.contents.draw_text(x, y, 240, 32, "Inflicts: " + state.name)
    elsif state_set.size == 2
      state1 = $data_states[state_set[0]]
      state2 = $data_states[state_set[1]]
      self.contents.font.color = system_color
      self.contents.draw_text(x, y, 240, 32, "Inflicts: " + state1.name +
      ", " + state2.name)
    else      
      rating = 0
      priority_state = ""
      total_states = state_set.size
      for i in state_set
        state = $data_states[i]
        if rating <= state.rating #if new state is higher priority
          rating = state.rating
          priority_state = state.name
        end
      end
      self.contents.font.color = system_color
      self.contents.draw_text(x, y, 240, 32, "Inflicts: " + priority_state +
      " and " + (total_states - 1).to_s + " others")
    end
  end
  
  #--------------------------------------------------------------------------
  # * Draw Def States - Draws states the armor prevents for a given actor
  #     state_set     : the guard state set for a given actor
  #     x             : draw spot x-coordinate
  #     y             : draw spot y-coordinate
  #     MOBIUS ADDED
  #--------------------------------------------------------------------------
  def draw_def_states(state_set, x, y)
    if state_set == []
      self.contents.font.color = system_color
      self.contents.draw_text(x, y, 240, 32, "Prevents: ")
    elsif state_set.size == 1
      state = $data_states[state_set[0]]
      self.contents.font.color = system_color
      self.contents.draw_text(x, y, 240, 32, "Prevents: " + state.name)
    elsif state_set.size == 2
      state1 = $data_states[state_set[0]]
      state2 = $data_states[state_set[1]]
      self.contents.font.color = system_color
      self.contents.draw_text(x, y, 240, 32, "Prevents: " + state1.name +
      ", " + state2.name)
    else      
      rating = 0
      priority_state = ""
      total_states = state_set.size
      for i in state_set
        state = $data_states[i]
        if rating <= state.rating #if new state is higher priority
          rating = state.rating
          priority_state = state.name
        end
      end
      self.contents.font.color = system_color
      self.contents.draw_text(x, y, 240, 32, "Prevents: " + priority_state +
      " and " + (total_states - 1).to_s + " others")
    end
  end
end
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
    #x = 4 + index % 2 * (288 + 32)  OLD
    x = 4
    #y = index / 2 * 32 OLD
    y = index * 32
    case item
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    bitmap = RPG::Cache.icon(item.icon_name)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
    self.contents.font.color = normal_color
    self.contents.draw_text(x + 28, y, 212, 32, item.name, 0)
    self.contents.draw_text(x + 240, y, 16, 32, ":", 1)
    self.contents.draw_text(x + 256, y, 24, 32, number.to_s, 2)
  end
end

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
    draw_actor_parameter(@actor, 4, 32, 0)  #ATK
    draw_actor_parameter(@actor, 4, 64, 1)  #PDEF
    draw_actor_parameter(@actor, 4, 96, 2)  #MDEF
    draw_actor_parameter(@actor, 4, 128, 3) #STR
    draw_actor_parameter(@actor, 4, 160, 4) #DEX
    draw_actor_parameter(@actor, 4, 192, 5) #AGI
    draw_actor_parameter(@actor, 4, 224, 6) #INT
    if @atk_element_set != nil
      draw_attack_elements(@atk_element_set, 4, 258)
    else
      draw_attack_elements(@actor.element_set, 4, 258)
    end
    if @def_element_set != nil
      draw_defense_elements(@def_element_set, 4, 292)
    else
      draw_defense_elements(@actor.defense_element_set, 4, 292)
    end    
    if  @plus_state_set != nil
      draw_plus_states(@plus_state_set, 4, 326)
    else
      draw_plus_states(@actor.plus_state_set, 4, 326)
    end
    if  @def_state_set != nil
      draw_def_states(@def_state_set, 4, 358)
    else
      draw_def_states(@actor.defense_state_set, 4, 358)
    end
    if @new_atk != nil
      self.contents.font.color = system_color
      self.contents.draw_text(160, 32, 40, 32, "->", 1)
      self.contents.font.color = color_choose(@actor.atk, @new_atk)
      self.contents.draw_text(200, 32, 36, 32, @new_atk.to_s, 2)
    end
    if @new_pdef != nil
      self.contents.font.color = system_color
      self.contents.draw_text(160, 64, 40, 32, "->", 1)
      self.contents.font.color = color_choose(@actor.pdef, @new_pdef)
      self.contents.draw_text(200, 64, 36, 32, @new_pdef.to_s, 2)
    end
    if @new_mdef != nil
      self.contents.font.color = system_color
      self.contents.draw_text(160, 96, 40, 32, "->", 1)
      self.contents.font.color = color_choose(@actor.mdef, @new_mdef)
      self.contents.draw_text(200, 96, 36, 32, @new_mdef.to_s, 2)
    end
    if @new_str != nil
      self.contents.font.color = system_color
      self.contents.draw_text(160, 128, 40, 32, "->", 1)
      self.contents.font.color = color_choose(@actor.str, @new_str)
      self.contents.draw_text(200, 128, 36, 32, @new_str.to_s, 2)
    end
    if @new_dex != nil
      self.contents.font.color = system_color
      self.contents.draw_text(160, 160, 40, 32, "->", 1)
      self.contents.font.color = color_choose(@actor.dex, @new_dex)
      self.contents.draw_text(200, 160, 36, 32, @new_dex.to_s, 2)
    end
    if @new_agi != nil
      self.contents.font.color = system_color
      self.contents.draw_text(160, 192, 40, 32, "->", 1)
      self.contents.font.color = color_choose(@actor.agi, @new_agi)
      self.contents.draw_text(200, 192, 36, 32, @new_agi.to_s, 2)
    end
    if @new_int != nil
      self.contents.font.color = system_color
      self.contents.draw_text(160, 224, 40, 32, "->", 1)
      self.contents.font.color = color_choose(@actor.int, @new_int)
      self.contents.draw_text(200, 224, 36, 32, @new_int.to_s, 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Set parameters after changing equipment
  #     new_atk  : attack power after changing equipment
  #     new_pdef : physical defense after changing equipment
  #     new_mdef : magic defense after changing equipment
  #     new_etc  : I think you get the picture
  #--------------------------------------------------------------------------
  def set_new_parameters(new_atk, new_pdef, new_mdef, new_str, new_dex, \
    new_agi, new_int)
    if @new_atk != new_atk or @new_pdef != new_pdef or @new_mdef != new_mdef or
      @new_str != new_str or @new_dex != new_dex or @new_agi != new_agi or
      @new_int != new_int
      @new_atk = new_atk
      @new_pdef = new_pdef
      @new_mdef = new_mdef
      @new_str = new_str
      @new_dex = new_dex
      @new_agi = new_agi
      @new_int = new_int
      refresh
    end
  end
  
  #--------------------------------------------------------------------------
  # * Set element_set after changing equipment
  #     element_set  : an array containing the new equipment's element_set
  #                    reference the database for element values
  #--------------------------------------------------------------------------
  def set_elements(atk_element_set, def_element_set)
    if @atk_element_set != atk_element_set or 
      @def_element_set != def_element_set
      @atk_element_set = atk_element_set
      @def_element_set = def_element_set
      refresh
    end
  end

  #--------------------------------------------------------------------------
  # * Set state_set after changing equipment
  #     state_set  : an array containing the new equipment's state_set
  #                    reference the database for state values
  #--------------------------------------------------------------------------
  def set_states(plus_state_set, def_state_set)
    if @plus_state_set != plus_state_set or @def_state_set != def_state_set
      @plus_state_set = plus_state_set
      @def_state_set = def_state_set
      refresh
    end
  end
#------------------------------------------------------------------------------
# * color_choose  
#   decide text color based on whether the stat improves
#   Mobius Added
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

end #class end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles the actor. It's used within the Game_Actors class
#  ($game_actors) and refers to the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler

  #--------------------------------------------------------------------------
  # * Get Normal Attack Element
  #--------------------------------------------------------------------------
  def element_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.element_set : []
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
  # * Get Normal Attack State Change (+)
  #--------------------------------------------------------------------------
  def plus_state_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.plus_state_set : []
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
end