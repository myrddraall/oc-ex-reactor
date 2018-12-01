local component = import("component");
local Class = import("oop/Class");
local TableUtil = import("../util/TableUtil");
local ReactorControl = Class("ReactorControl");


function ReactorControl:initialize(reactorProxyOrAddress)
    if reactorProxyOrAddress == nil then
        self.reactor = component.br_reactor;
    elseif type(reactorProxyOrAddress) == "string" then
        self.reactor = component.proxy(reactorProxyOrAddress);
    else
        self.reactor = reactorProxyOrAddress;
    end
end

function ReactorControl:get_isUsable()
    return self.reactor and self.reactor.getMultiblockAssembled();
end

function ReactorControl:get_isActivelyCooled()
    return self.reactor.isActivelyCooled();
end

function ReactorControl:get_active()
    return self.reactor.getActive();
end

function ReactorControl:set_active(value)
    self.reactor.setActive(value);
end

-- coolent (water)
function ReactorControl:get_coolentType()
    return self.reactor.getCoolentType();
end

function ReactorControl:get_coolantAmount()
    return self.reactor.getCoolantAmount();
end

function ReactorControl:get_coolantMax()
    return self.reactor.getCoolantAmountMax();
end

function ReactorControl:get_coolantPercent()
    return self.coolantAmount / self.coolantMax;
end

-- Hot Fluid (steam)
function ReactorControl:get_hotFluidType()
    return self.reactor.getCoolentType();
end

function ReactorControl:get_hotFluidAmount()
    return self.reactor.getCoolantAmount();
end

function ReactorControl:get_hotFluidMax()
    return self.reactor.getCoolantAmountMax();
end

function ReactorControl:get_hotFluidPercent()
    return self.hotFluidAmount / self.hotFluidMax;
end

function ReactorControl:get_hotFluidMadeLastTick()
    return self.reactor.getHotFluidProducedLastTick();
end

-- fuel
function ReactorControl:get_fuelAmount()
    return self.reactor.getFuelAmount();
end

function ReactorControl:get_fuelMax()
    return self.reactor.getFuelAmountMax();
end

function ReactorControl:get_fuelPercent()
    return self.fuelAmount / self.fuelMax;
end

function ReactorControl:get_reactivity()
    return self.reactor.getFuelReactivity();
end

function ReactorControl:get_fuelUsedLastTick()
    return self.reactor.getFuelConsumedLastTick();
end

-- waste
function ReactorControl:get_wasteAmount()
    return self.reactor.getWasteAmount();
end

function ReactorControl:get_wasteMax()
    return self.reactor.getFuelAmountMax();
end

function ReactorControl:get_wastePercent()
    return self.wasteAmount / self.wasteMax;
end

-- energy
function ReactorControl:get_energyAmount()
    return self.reactor.getEnergyStored();
end

function ReactorControl:get_energyMax()
    return self.reactor.getEnergyCapacity();
end

function ReactorControl:get_energyPercent()
    return self.energyAmount / self.energyMax;
end

function ReactorControl:get_energyMadeLastTick()
    return self.reactor.getEnergyProducedLastTick();
end

-- temp
function ReactorControl:get_caseTemp()
    return self.reactor.getCasingTemperature();
end

function ReactorControl:get_coreTemp()
    return self.reactor.getFuelTemperature();
end

-- rods
function ReactorControl:calcRodLevel()
    local ctrLvl = self.reactor.getControlRodsLevels();
    table.insert(ctrLvl, ctrLvl[0]);
    return self.rodLevelMax - TableUtil.sum(ctrLvl);
end


function ReactorControl:get_numRods()
    return self.reactor.getNumberOfControlRods();
end 
function ReactorControl:get_rodLevelMax()
    return self.reactor.getNumberOfControlRods() * 100;
end 

function ReactorControl:get_rodLevel()
    if self._rodLevel == nil then
        self._rodLevel = self:calcRodLevel();
    end
    return self._rodLevel;
end 

function ReactorControl:set_rodLevel(value)
    local max = self.rodLevelMax;
    if value < 0 then
        value = 0;
    end
    if value > max then
        value = max;
    end
    value = math.floor(value);
    if self._rodLevel ~= value then
        self._rodLevel = value;
        value = max - value;
        
        local rods = self.numRods;
        local v = math.floor(value / rods);

        local r = value - (v * rods); 

        local rodLevels = {};
        for i = 1, rods do
            local rodVal = v;
            if i <= r then
                rodVal = v + 1;
            end
            if i == 1 then
                rodLevels[0] = rodVal;
            else 
                table.insert(rodLevels, rodVal);
            end
        end
        
        self.reactor.setControlRodsLevels(rodLevels);
    end
end

function ReactorControl:get_rodLevelPercent()
    return self.rodLevel / self.rodLevelMax;
end 

return ReactorControl;