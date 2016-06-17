--[[
    This isn't the file you are wanting to edit.
    /config/ folder has the actual default config values used by the mod. :)
]]

--Factorio provided libs
require "defines"

require "config.defaults"
require "config.player_defaults"
require "config.position_defaults"

if not CTLM then CTLM = {} end
if not CTLM.config then CTLM.config = {} end
if not CTLM.gui then CTLM.gui = {} end

--Fix/install config!
function CTLM.config.init()
    if not global.config then
        global.config = CTLM.config.deepCopy(config.defaults);
    end
    if not global.players then
        global.players = {};
    end
    if not global.positions then
        global.positions = {};
    end
end

function CTLM.config.load()
    CTLM.config.main = global.config;
    CTLM.config.players = global.players;
    CTLM.config.positions = global.positions;
end

function CTLM.config.new_player(player)
    if type(player) == "table" and player.valid then
        --do nothing this is actually the type we are after. :)
    elseif type(player) == "string" or type(player) == "integer" then
        --Probably an index or name of a player. Get the player from the game variable.
        player = game.get_player(player);
    else
        CTLM.log("Unsupported player type given as parameter '" .. type(player) .. "'.");
    end

    if not global.players[player.name] then
        global.players[player.name] = CTLM.config.deepCopy(config.player_defaults);
        --Stored for when we just pass around a lua table of this player with out the proceeding named index.
        global.players[player.name].name = player.name;
    end
end

function CTLM.config.new_surface(surface)
    if type(surface) == "table" and surface.valid then
        --do nothing this is actually the type we are after. :)
    elseif type(surface) == "string"  or type(surface) == "integer" then
        --Probably an index or name of a surface. Get the surface from the game variable.
        surface = game.get_surface(surface);
    else
        CTLM.log("Unsupported surface type given as parameter '" .. type(surface) .. "'.");
    end

    if not global.surfaces[surface.name] then
        global.surfaces[surface.name] = CTLM.config.deepCopy(config.surface_defaults);
        --Stored for when we just pass around a lua table of this surface with out the proceeding named index.
        global.surfaces[surface.name].name = surface.name;
    end
end

------------------------------------------------------------------------------------------------------
--Special functions
------------------------------------------------------------------------------------------------------

-- Found on Internet. Original author unknown.
-- deep copies a table to avoid references as that would be bad. :/
function CTLM.config.deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end
