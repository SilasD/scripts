-- Resize armor and clothing.

local argparse = require('argparse')
local utils = require('utils')

local function isValidItem(item)
    local itemTypes = {
        df.item_type.ARMOR,
        df.item_type.SHOES,
        df.item_type.GLOVES,
        df.item_type.HELM,
        df.item_type.PANTS,
    }
    if not utils.linear_index(itemTypes, item:getType()) or
        item.flags.in_job or
        item.flags.hostile or
        item.flags.removed or
        item.flags.dead_dwarf or
        item.flags.rotten or
        item.flags.spider_web or
        item.flags.construction or
        item.flags.encased or
        item.flags.trader or
        item.flags.garbage_collect or
        item.flags.forbid or
        item.flags.dump or
        item.flags.on_fire or
        item.flags.melt
    then
        return false
    end
    return true
end

local function GetStockpileItems(stockpile)
    local stockPileItems = dfhack.buildings.getStockpileContents(stockpile)
    local items = {}
    for _, stockPileItem in ipairs(stockPileItems) do
        if #stockPileItems > 0 and isValidItem(stockPileItem) then
            table.insert(items, stockPileItem)
        end
    end
    return items
end

local function GetRace()
    local race
    if dfhack.world.isAdventureMode() then
        race = dfhack.world.getAdventurer().race
    elseif dfhack.world.isFortressMode() then
        local site = dfhack.world.getCurrentSite()
        for _, entityLink in ipairs(site.entity_links) do
            local entity = df.historical_entity.find(entityLink.entity_id)
            if entity and entity.type == df.historical_entity_type.Civilization then
                race = entity.race
                break
            end
        end
    end
    return race
end

local function ResizeItems(items, race)
    local raceName = race and dfhack.units.getRaceNamePluralById(race)
    local resizeCount = 0
    for _, item in ipairs(items) do
        local itemName = item and dfhack.items.getReadableDescription(item)
        if item:getMakerRace() ~= race then
            item:setMakerRace(race)
            item:calculateWeight()
            resizeCount = resizeCount + 1
            if #items == 1 then print(('%s resized for %s.'):format(itemName, raceName)) end
        elseif #items == 1 then print(('%s is already sized for %s.'):format(itemName, raceName)) end
    end
    if resizeCount > 1 then
        print(('%d items resized for %s.'):format(resizeCount, raceName))
    elseif resizeCount == 0 and #items > 1 then
        print(('All items are already sized for %s'):format(raceName))
    end
end

local function ParseCommandLine(args)
    local options = {
        help = false,
        race = nil,
    }
    local positionals = argparse.processArgsGetopt(args, {
        {'h', 'help', handler = function() options.help = true end},
        {'r', 'race', hasArg = true, handler = function(arg) options.race = argparse.nonnegativeInt(arg, 'race') end},
    })
    return options
end

local function Main(args)
    local options = ParseCommandLine(args)
    if args[1] == 'help' or options.help then
        print(dfhack.script_help())
        return
    end
    local items = {}
    local item = dfhack.gui.getSelectedItem(true)
    if item then
        if isValidItem(item) then
            table.insert(items, item)
        else
            qerror('Selected item cannot be resized.')
        end
    elseif dfhack.world.isFortressMode() then
        local stockpile = dfhack.gui.getSelectedStockpile(true)
        if stockpile and df.building_stockpilest:is_instance(stockpile) then
            items = GetStockpileItems(stockpile)
            if #items < 1 then qerror('Selected stockpile contains no items that can be resized.') end
        end
    end
    if #items > 0 then
        local race = options.race or GetRace()
        if not race then
            qerror('Unable to obtain race ID. Please specify race ID manually.')
        end
        ResizeItems(items, race)
    else
        if dfhack.world.isAdventureMode() then
            qerror('No item selected.')
        elseif dfhack.world.isFortressMode() then
            qerror('No item or stockpile selected.')
        end
    end
end

if not dfhack.isMapLoaded() or (
        not dfhack.world.isAdventureMode() and not dfhack.world.isFortressMode()
    )
then
    qerror('This script requires the game to be in adventure or fortress mode.')
end

Main({...})
