local component = import("component");
local Class = import("oop/Class");

local TurbineControl = Class("TurbineControl");

function TurbineControl:initialize(turbineProxyOrAddress)
    if turbineProxyOrAddress == nil then
        error("Turbine address or proxy required", 2);
    elseif type(turbineProxyOrAddress) == "string" then
        self.turbine = component.proxy(turbineProxyOrAddress);
    else
        self.turbine = turbineProxyOrAddress;
    end
end



function TurbineControl:get_isUsable()
    return self.turbine and self.turbine.getMultiblockAssembled();
end

-- blades/rotor

function TurbineControl:get_bladeEfficiency()
    return self.turbine.getBladeEfficiency();
end

function TurbineControl:get_rotorMass()
    return self.turbine.getRotorMass();
end

function TurbineControl:get_rotorSpeed()
    return self.turbine.getRotorSpeed();
end

function TurbineControl:get_numBlades()
    return self.turbine.getNumberOfBlades();
end

-- energy
function TurbineControl:get_energyAmount()
    return self.turbine.getEnergyStored();
end

function TurbineControl:get_energyMax()
    return self.turbine.getEnergyCapacity();
end

function TurbineControl:get_energyPercent()
    return self.energyAmount / self.energyMax;
end

function TurbineControl:get_energyMadeLastTick()
    return self.turbine.getEnergyProducedLastTick();
end


-- steam

function TurbineControl:get_flowRate()
    return self.turbine.getFluidFlowRate();
end

-- controll

function TurbineControl:get_active()
    return self.turbine.getActive();
end

function TurbineControl:set_active(value)
    self.turbine.setActive(value);
end

function TurbineControl:get_engaged()
    return self.turbine.getInductorEngaged();
end

function TurbineControl:set_engaged(value)
    self.turbine.setInductorEngaged(value);
end

function TurbineControl:get_flowRateLimit()
    return self.turbine.getFluidFlowRateMax();
end

function TurbineControl:set_flowRateLimit(value)
    self.turbine.setFluidFlowRateMax(value);
end

    
    return TurbineControl;