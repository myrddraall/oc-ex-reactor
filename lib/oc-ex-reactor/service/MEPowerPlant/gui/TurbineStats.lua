
local Class = import("oop/Class");
local Group = import("oc-gui/core/Group");
local Container = import("oc-gui/core/Container");
local Text = import("oc-gui/common/Text");
local Progressbar = import("oc-gui/common/Progressbar");
local TurbineStats = Class("TurbineStats", Group);

function TurbineStats:initialize(index, control)
    Group.initialize(self);
    self.control = control;
    self.index = index;
    self.lblTitle = Text:new();
    self.lblTitle.text = "Turbine " .. index;
    self.lblTitle.textAlign = "left";
    self.lblTitle.y = 0;
    self.lblTitle.left = 1;
    self.lblTitle.right = 1;
    self.lblTitle.height = 1;
    self.lblTitle.foreground = 0x00ff00;
    self:_addElement(self.lblTitle);

    self.prgbar = Progressbar:new();
    self.prgbar.value = 0;
    self.prgbar.y = 1;
    self.prgbar.left = 1;
    self.prgbar.right = 1;
    self.prgbar.width = "auto";
    self.prgbar.height = 1;
    self.prgbar.barColor = 0xffff00;
    self.prgbar.barBgColor = 0x333333;
    self.prgbar.maxValue = 1;
    --self.txtCaseTemp.foreground = 0x00ff00;
    self:_addElement(self.prgbar);
end

function TurbineStats:update()
    local statusText = "Turbine " .. self.index;
    if not self.control.isUsable then
        self.lblTitle.foreground = 0xff0000;
        statusText = statusText .. " - BROKEN";
        self.prgbar.value = 0;
    elseif not self.control.active then
        self.lblTitle.foreground = 0x666666;
        statusText = statusText .. " - Offline";
        self.prgbar.value = 0;
    else
        if self.control.rotorSpeed < 1780 then
            self.lblTitle.foreground = 0x006600;
            statusText = statusText .. " - Spining Up";
            local p = self.control.rotorSpeed / 1780;
            if p < 0.70 then
                self.prgbar.barColor = 0xff0000;
            elseif p < 0.90 then
                self.prgbar.barColor = 0xff6600;
            else
                self.prgbar.barColor = 0xffff00;
            end
            self.prgbar.value = p;
        elseif self.control.rotorSpeed > 1800 then
            self.lblTitle.foreground = 0x006600;
            statusText = statusText .. " - Throttling";
            self.prgbar.value = 0;
        else
            if self.control.engaged then
                self.lblTitle.foreground = 0x00ff00;
                statusText = statusText .. " - Generating";
                self.prgbar.barColor = 0xAA0000;
                self.prgbar.value = self.control.energyPercent;
            else
                self.lblTitle.foreground = 0x00ff00;
                statusText = statusText .. " - Idel";
                self.prgbar.barColor = 0xAA0000;
                self.prgbar.value = self.control.energyPercent;
            end
        end
    end
    self.lblTitle.text = statusText;
end


return TurbineStats;