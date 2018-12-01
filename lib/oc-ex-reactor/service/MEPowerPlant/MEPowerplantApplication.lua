
local GuiApplication = import("oc-gui/core/GuiApplication");
local Gui = import("oc-gui/core/Gui");
local Class = import("oop/Class");
local component = import("component");
local event = import("event");
local Label = import("oc-gui/common/Label");
local Text = import("oc-gui/common/Text");
local Container = import("oc-gui/core/Container");
local ReactorCalibration = import("./ReactorCalibration");
local IngotAverage = import("../../util/IngotAverage");
local ReactorStats = import("./gui/ReactorStats");
local FuelStats = import("./gui/FuelStats");
local TurbineStats = import("./gui/TurbineStats");
local ReactorControl = import("../../control/ReactorControl");
local TurbineControl = import("../../control/TurbineControl");


local MEPowerplantApplication = Class("MEPowerplantApplication", GuiApplication);

function MEPowerplantApplication:createGuis(guis)
    component.gpu.setResolution(160, 40);
    component.gpu.setViewport(80, 40);
    self.rc = ReactorControl:new();
    self.calibration = ReactorCalibration:new();
    self.ingotAverage = IngotAverage:new();
    self.updateRate = 0.25;
    event.listen("redstone_changed", function(evt, address, side, oldValue, newValue)
        if newValue == 0 then
            self.ingotAverage:added();
        end
     end)

    local main = Gui:new();
    main.x = 80;
    main.width = 80;
    -- main.background = 0xff00ff;
    self.reactorStats = ReactorStats:new();
    self.reactorStats.width = "50%";
    self.reactorStats.height = 10;
    --self.reactorStats.background = 0xff0000;

    main:addChild(self.reactorStats);


    self.fuelStats = FuelStats:new();
    self.fuelStats.x = "50%";
    self.fuelStats.width = "50%";
    self.fuelStats.height = 10;
    --self.fuelStats.background = 0xff0000;

    main:addChild(self.fuelStats);

    self.turbineContainer = Container:new();
    self.turbineContainer.left = 1;
    self.turbineContainer.right = 1;
    self.turbineContainer.height = 28;
    self.turbineContainer.y = 10;
    --self.turbineContainer.background = 0xff0000;
    main:addChild(self.turbineContainer);

    self:_initTurbines(self.turbineContainer);

    guis.main = main;
    self:setActiveGui("main");
end

function MEPowerplantApplication:_updateGui()
    GuiApplication._updateGui(self);
    if self._activeGui then
        --print('copy')
        component.gpu.copy(80, 0, 81, 40, -80, 0);
    end
end

function MEPowerplantApplication:_initTurbines(parent)
    local list = component.list("br_turbine");
    self.turbineControllers = {};
    self.turbineElements = {};
    local c = 0;
    for i=1, 18 do
    for address, _ in pairs(list) do
        local control = TurbineControl:new(address);
        table.insert(self.turbineControllers, control);
    
        local col = c % 2;
        local row = math.floor(c / 2);

        local elm = TurbineStats:new(c + 1, control);
        elm.width = "50%";
        elm.height = 3;
        if col == 0 then
            elm.x = 0;
        else
            elm.x = "50%";
        end
        elm.y = row * 3;
        --elm.background = 0xff00ff;
        table.insert(self.turbineElements, elm);
        parent:addChild(elm);
        c = c + 1;
    end
    end
end

function MEPowerplantApplication:update()
   -- print("update")
   self.reactorStats.state = self.rc.active;
   self.reactorStats.coreTemp =  math.floor(self.rc.coreTemp * 10) / 10;
   self.reactorStats.caseTemp =  math.floor(self.rc.caseTemp * 10) / 10;
   self.reactorStats.rodLevel =  self.rc:calcRodLevel();
   self.reactorStats.reactivity = self.rc.reactivity;
   self.reactorStats.rodLevelMax = self.calibration.rodLevelMax;
   self.reactorStats.steamProduced = self.rc.hotFluidMadeLastTick;

   self.fuelStats.wasteAmount = self.rc.wasteAmount;
   self.fuelStats.currentIngotTime = self.ingotAverage:get();

   self.fuelStats:updateIngotStats(self.ingotAverage);

   for _, turb in ipairs(self.turbineElements) do
    turb:update();
   end
end


return MEPowerplantApplication;