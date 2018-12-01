local Class = import("oop/Class");
local thread = import("thread");
local component = require("component");
local ReactorCalibration = import("./ReactorCalibration");
local ReactorControl = import("../../control/ReactorControl");
local TurbineControl = import("../../control/TurbineControl");
local MEPowerPlantService = Class("MEPowerPlantService");

function MEPowerPlantService:initialize()
    self.calibration = ReactorCalibration:new();
    self.meController = component.me_controller;
    self.reactorControl = ReactorControl:new();
    self.maxSteam = 32000000;
    self:_initTurbines();
end

function MEPowerPlantService:_initTurbines()
    self.turbines = {};
    local list = component.list("br_turbine");
    for address, _ in pairs(list) do
        local tc = TurbineControl:new(address);
        if tc.isUsable then
            table.insert(self.turbines, tc);
        end
    end
end

function MEPowerPlantService:start(asService)
    self.calibration:calibrateIfNeeded();
    local err = nil;
    local mainThread = thread.create(function(pp)
        local succes, error = xpcall(pp._run, function(err) 
            return err;
        end, pp);
        if not succes then
            print(error);
        end
    end, self);

    if asService then
        mainThread:detach();
        return mainThread;
    else
        thread.waitForAll({mainThread});
        if err then
            print(err);
        end
    end

end

function MEPowerPlantService:_getMeFluid(name)
    local fluids = self.meController.getFluidsInNetwork();
    for _,f in ipairs(fluids) do
        if f.name == name then
            return f;
        end
    end 
end

function MEPowerPlantService:get_steamAmount()
    local steam = self:_getMeFluid("steam");
    if not steam then
        return 0;
    end
    return steam.amount;
end

function MEPowerPlantService:get_steamPercent()
    return self.steamAmount / self.maxSteam;
end

function MEPowerPlantService:_run()
    self._isRunning = true;
    while self._isRunning do
        local steamPercentFree = 1 - self.steamPercent;
        local rodLevel = (steamPercentFree * (self.calibration.rodLevelMax - self.calibration.rodLevelMin)) + self.calibration.rodLevelMin;
        rodLevel = math.max(rodLevel, math.floor(self.calibration.rodLevelMin));
        self.reactorControl.rodLevel = rodLevel;
        self:_manageTurbines();
        os.sleep(0.5);
    end
end


function MEPowerPlantService:_manageTurbines()
    for i=1, #self.turbines do
        local turb = self.turbines[i];
        if turb.active then
            if turb.rotorSpeed > 1800 then
                turb.engaged = true;
                turb.flowRateLimit = 0;
            elseif turb.rotorSpeed < 1780 then
                turb.engaged = false;
                turb.flowRateLimit = 2000;
            else
                if turb.energyPercent > 0.8 and turb.engaged then
                    turb.engaged = false;
                    turb.flowRateLimit = 5;

                elseif turb.energyPercent < 0.3 and not turb.engaged then
                    turb.flowRateLimit = 2000;
                    turb.engaged = true;
                end
            end 
        end
    end
end

function MEPowerPlantService:stop()
    self._isRunning = false;
end

return MEPowerPlantService;