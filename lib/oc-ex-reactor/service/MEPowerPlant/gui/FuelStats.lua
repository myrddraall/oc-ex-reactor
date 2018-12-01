
local Class = import("oop/Class");
local Group = import("oc-gui/core/Group");
local Container = import("oc-gui/core/Container");
local Text = import("oc-gui/common/Text");
local Progressbar = import("oc-gui/common/Progressbar");
local FuelStats = Class("FuelStats", Group);

function FuelStats:initialize()
    Group.initialize(self);

    self.lblTitle = Text:new();
    self.lblTitle.text = "Fuel";
    self.lblTitle.textAlign = "center";
    self.lblTitle.y = 0;
    self.lblTitle.width = "100%";
    self.lblTitle.height = 1;
    self.lblTitle.foreground = 0x00ff00;
    self:_addElement(self.lblTitle);

    self.lblCurrIngot = Text:new();
    self.lblCurrIngot.text = "Ingot Time: ";
    self.lblCurrIngot.textAlign = "right";
    self.lblCurrIngot.y = 1;
    self.lblCurrIngot.width = 13;
    self.lblCurrIngot.height = 1;
    self.lblCurrIngot.foreground = 0x00ff00;
    self:_addElement(self.lblCurrIngot);

    self.txtCurrIngotTime = Text:new();
    self.txtCurrIngotTime.text = "-";
    self.txtCurrIngotTime.textAlign = "left";
    self.txtCurrIngotTime.y = 1;
    self.txtCurrIngotTime.x = "35%"
    self.txtCurrIngotTime.width = "30%";
    self.txtCurrIngotTime.height = 1;
    self.txtCurrIngotTime.foreground = 0x00ff00;
    self:_addElement(self.txtCurrIngotTime);


    self.prgIngot = Progressbar:new();
    self.prgIngot.value = 0;
    self.prgIngot.y = 2;
    self.prgIngot.left = 1;
    self.prgIngot.right = 6;
    self.prgIngot.width = "auto";
    self.prgIngot.height = 1;
    self.prgIngot.barColor = 0xffff00;
    self.prgIngot.barBgColor = 0x00ffff;
    self.prgIngot.maxValue = 1;
    --self.txtCaseTemp.foreground = 0x00ff00;
    self:_addElement(self.prgIngot);
    
    self.lblIngotStats = Text:new();
    self.lblIngotStats.text = [[Last: 
Last 2: 
Last 4: 
Last 8: 
Last 16: ]];
    self.lblIngotStats.textAlign = "right";
    self.lblIngotStats.y = 4;
    self.lblIngotStats.width = "30%";
    self.lblIngotStats.height = 5;
    self.lblIngotStats.foreground = 0x00ff00;
    self:_addElement(self.lblIngotStats);

    self.txtIngotStats = Text:new();
    self.txtIngotStats.text = "";
    self.txtIngotStats.textAlign = "left";
    self.txtIngotStats.y = 4;
    self.txtIngotStats.x = "30%";
    self.txtIngotStats.width = "30%";
    self.txtIngotStats.height = 5;
    self.txtIngotStats.foreground = 0x00ff00;
    self:_addElement(self.txtIngotStats);

end


function FuelStats:get_wasteAmount()
    return self._wasteAmount;
end

function FuelStats:set_wasteAmount(value)
    if self._wasteAmount ~= value then
        self._wasteAmount = value;
        self.prgIngot.value = (1000 - value) / 1000;
    end
end


function FuelStats:get_currentIngotTime()
    return self._currentIngotTime;
end

function FuelStats:set_currentIngotTime(value)
    
   if self._currentIngotTime ~= value then
        self._currentIngotTime = value;
        if value == -1 then
            self.txtCurrIngotTime.text = "-"
        else
            self.txtCurrIngotTime.text = (math.floor(value * 10 + 0.5) / 10) .. "s";
        end
   end
end

function FuelStats:updateIngotStats(averager)
    local stats = "";

    local stat = averager:get(1);
    if stat == -1 then
        stats = stats .. "-\n";
    else
        stats = stats .. stat .. "s\n";
    end

    stat = averager:get(2);

    if stat == -1 then
        stats = stats .. "-\n";
    else
        stats = stats .. stat .. "s\n";
    end

    stat = averager:get(4);
    if stat == -1 then
        stats = stats .. "-\n";
    else
        stats = stats .. stat .. "s\n";
    end

    stat = averager:get(8);
    if stat == -1 then
        stats = stats .. "-\n";
    else
        stats = stats .. stat .. "s\n";
    end

    stat = averager:get(16);
    if stat == -1 then
        stats = stats .. "-\n";
    else
        stats = stats .. stat .. "s\n";
    end
    self.txtIngotStats.text = stats;
end

return FuelStats;