local Class = import("oop/Class");
local fs = require("filesystem");
local thread = import("thread");
local json = import("json");
local term = import("term");
local ReactorControl = import("../../control/ReactorControl");

local Average = import("../../util/Average");



local CALIBRATION_CONFIG_PATH = "/usr/reactor_calibration.json";


local ReactorCalibration = Class("ReactorCalibration");

function ReactorCalibration:initialize(reactorProxyOrAddress)
    self._currentRodLevel = -1;
    self.reactor = ReactorControl:new(reactorProxyOrAddress);
    if not self.reactor.isUsable then
        error("Could not find a usable reactor");
    end
    if not self.reactor.isActivelyCooled then
        error("Reactor is not actively cooled");
    end
    self:_loadConfig();
end

function ReactorCalibration:_loadConfig()
   
    if fs.exists(CALIBRATION_CONFIG_PATH) then
        local file = fs.open(CALIBRATION_CONFIG_PATH, "r");
        local jsonData = file:read(fs.size(CALIBRATION_CONFIG_PATH));
        file:close();
        self.config = json.decode(jsonData);
    end
end

function ReactorCalibration:_saveConfig()
    local jsonStr = json.encode(self.config, {indent=2});
    local file = fs.open(CALIBRATION_CONFIG_PATH, "w");
    file:write(jsonStr);
    file:close();
end

function ReactorCalibration:calibrateIfNeeded()
    if not self.config then
        local calibrationThread = thread.create(function(rc)
            local succes, error = xpcall(rc._doCalibration, function(err) 
                return err;
            end, rc);
            if not succes then
                print(error);
            end
                   
        end, self);
        thread.waitForAll({calibrationThread});
    end
end

function ReactorCalibration:_getCurrentRodLevel()
    return self._currentRodLevel;
end

function ReactorCalibration:_setCurrentRodLevel(value)
    if self._currentRodLevel ~= value then
        self._currentRodLevel = value;
        self.reactor.rodLevel = value;
    end
end

function ReactorCalibration:get_rodLevelMax()
    if self.config then
        return self.config.maxControlRodLevel;
    end
    return nil;
end

function ReactorCalibration:get_rodLevelMin()
    if self.config then
        return self.config.minControlRodLevel;
    end
    return nil;
end

function ReactorCalibration:_doCalibration()
    term.clear();
    self.config = {
        minControlRodLevel = 0;
    };
    
    local targetTemp = 99;
    self.reactor.active = true;
    self:_setCurrentRodLevel(0);
    term.clear();
    print("Reactor Calibration")
    while self.reactor.coreTemp > targetTemp do
        term.clear();
        print("Reactor Calibration")
        print("Waiting for reactor to cool...")
        print("Core Temp: " .. self.reactor.coreTemp .. "C / " .. targetTemp .. 'C');
        print("Rod Level: ", self:_getCurrentRodLevel());
        os.sleep(0.05);
    end
    os.sleep(5);
    local done = false;
    local targetSteam = 50000;
    local lastAvg = nil;
    local lastInc = nil;
    local cycle = 1;
    while not done do
        term.clear();
        print("Reactor Calibration");
        print("Finding max control rod level...");
        if lastAvg then
            print("Average Steam over the last 5 seconds:", lastAvg .. ' mB/tick');
            print("Increased Rod Level By:", lastInc);
            print("Current Rod Level:", self:_getCurrentRodLevel());
        end
        print("Taking 5 second average of steam generation...");
        print("Cycle:", cycle);
        local avgSteam = Average:new();
        for i = 1, 100 do
            avgSteam:add(self.reactor.hotFluidMadeLastTick);
            os.sleep(0.05);
        end
        cycle = cycle + 1;
        lastAvg = avgSteam:get();

        if lastAvg < targetSteam then
            local pOfT = lastAvg /  targetSteam;
            lastInc = (1 - pOfT) * 1000;
            self:_setCurrentRodLevel(self:_getCurrentRodLevel() + lastInc);
        else 
            done = true;
        end
    end
    local maxRodLevel = math.ceil(self:_getCurrentRodLevel());
    term.clear();
    print("Reactor Calibration");
    print("Max Rod Level Found");
    print("Max Rod Level:", maxRodLevel);
    print("Reactor Calibration Complete.");
    self.config.maxControlRodLevel = maxRodLevel;
    self:_saveConfig();
    self:_setCurrentRodLevel(0);
    os.sleep(5);
end

return ReactorCalibration;