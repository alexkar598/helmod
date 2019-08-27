require "selector.AbstractSelector"
-------------------------------------------------------------------------------
-- Class to build technology selector
--
-- @module EntitySelector
-- @extends #AbstractSelector
--

EntitySelector = class(AbstractSelector)

-------------------------------------------------------------------------------
-- Return caption
--
-- @function [parent=#EntitySelector] getCaption
--
-- @param #Controller parent parent controller
--
function EntitySelector:getCaption(parent)
  return {"helmod_selector-panel.entity-title"}
end

-------------------------------------------------------------------------------
-- After initialization
--
-- @function [parent=#EntitySelector] afterInit
--
function EntitySelector:afterInit()
  Logging:debug(self.classname, "afterInit()")
  self.disable_option = true
  self.hidden_option = true
  self.product_option = false
end

-------------------------------------------------------------------------------
-- Append groups
--
-- @function [parent=#EntitySelector] appendGroups
--
-- @param #string name
-- @param #string type
--
function EntitySelector:appendGroups(name, type)
  Logging:debug(self.classname, "appendGroups()", name, type)
  EntityPrototype.load(name, type)
  local find = self:checkFilter(EntityPrototype.native())
  local filter_show_disable = User.getSetting("filter_show_disable")
  local filter_show_hidden = User.getSetting("filter_show_hidden")
  
  local list_group = Cache.getData(self.classname, "list_group")
  local list_prototype = Cache.getData(self.classname, "list_prototype")
  local list_subgroup = Cache.getData(self.classname, "list_subgroup")
  
  if find == true and (EntityPrototype.getValid() == true or filter_show_disable == true) then
    local group_name = EntityPrototype.native().group.name
    local subgroup_name = EntityPrototype.native().subgroup.name
    
    list_subgroup[subgroup_name] = EntityPrototype.native().subgroup
    
    if list_group[group_name] == nil then
      list_group[group_name] = {name=group_name, search_products="", search_ingredients=""}
    end
    list_subgroup[subgroup_name] = EntityPrototype.native().subgroup
    if list_prototype[group_name] == nil then list_prototype[group_name] = {} end
    if list_prototype[group_name][subgroup_name] == nil then list_prototype[group_name][subgroup_name] = {} end
    
    local search_products = name
    list_group[group_name].search_products = list_group[group_name].search_products .. search_products
    
    local search_ingredients = name
    list_group[group_name].search_ingredients = list_group[group_name].search_ingredients .. search_ingredients

    table.insert(list_prototype[group_name][subgroup_name], {name=name, type=type, order=EntityPrototype.native().order, search_products=search_products, search_ingredients=search_ingredients})
  end
end

-------------------------------------------------------------------------------
-- Update groups
--
-- @function [parent=#EntitySelector] updateGroups
--
-- @param #LuaEvent event
-- @param #string action action name
-- @param #string item first item name
-- @param #string item2 second item name
-- @param #string item3 third item name
--
function EntitySelector:updateGroups(event, action, item, item2, item3)
  Logging:trace(self.classname, "updateGroups()", action, item, item2, item3)
  
  self:resetGroups()

  for key, entity in pairs(Player.getEntityPrototypes()) do
    self:appendGroups(entity.name, "entity")
  end
end

-------------------------------------------------------------------------------
-- Build prototype tooltip
--
-- @function [parent=#EntitySelector] buildPrototypeTooltip
--
-- @param #LuaPrototype prototype
--
function EntitySelector:buildPrototypeTooltip(prototype)
  Logging:trace(self.classname, "buildPrototypeTooltip(player, prototype):", prototype)
  -- initalize tooltip
  local tooltip = EntityPrototype.load(prototype).getLocalisedName()
  return tooltip
end

-------------------------------------------------------------------------------
-- Build prototype icon
--
-- @function [parent=#EntitySelector] buildPrototypeIcon
--
function EntitySelector:buildPrototypeIcon(guiElement, prototype, tooltip)
  Logging:trace(self.classname, "buildPrototypeIcon(player, guiElement, prototype, tooltip:",player, guiElement, prototype, tooltip)
  ElementGui.addGuiButtonSelectSprite(guiElement, self.classname.."=element-select=ID=entity=", "entity", prototype.name, prototype.name, tooltip)
end



