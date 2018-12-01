
local Class = import("oop/Class");
local Group = import("oc-gui/core/Group");
local Text = import("oc-gui/common/Text");
local Progressbar = import("oc-gui/common/Progressbar");
local ReactorStats = Class("ReactorStats", Group);

function ReactorStats:initialize()
    Group.initialize(self);
    local cw = 20;
    local colWidth = cw .. "%";
    local row = 0;
    self.lblTitle = Text:new();
    self.lblTitle.text = "Reactor";
    self.lblTitle.textAlign = "center";
    self.lblTitle.y = row;
    self.lblTitle.width = "100%";
    self.lblTitle.height = 1;
    self.lblTitle.foreground = 0x00ff00;
    self:_addElement(self.lblTitle);

    row = row + 1;

    self.lblState = Text:new();
    self.lblState.text = "State: ";
    self.lblState.textAlign = "right";
    self.lblState.y = row;
    self.lblState.width = colWidth;
    self.lblState.height = 1;
    self.lblState.foreground = 0x00ff00;
    self:_addElement(self.lblState);

    self.txtState = Text:new();
    self.txtState.text = " - ";
    self.txtState.left = colWidth;
    self.txtState.y = row;
    self.txtState.width = "50%";
    self.txtState.height = 1;
    self.txtState.foreground = 0x00ff00;
    self:_addElement(self.txtState);

    row = row + 1;
    
    self.lblCoreTemp = Text:new();
    self.lblCoreTemp.text = "Core: ";
    self.lblCoreTemp.textAlign = "right";
    self.lblCoreTemp.y = row;
    self.lblCoreTemp.width = colWidth;
    self.lblCoreTemp.height = 1;
    self.lblCoreTemp.foreground = 0x00ff00;
    self:_addElement(self.lblCoreTemp);

    self.txtCoreTemp = Text:new();
    self.txtCoreTemp.text = " - ";
    self.txtCoreTemp.left = colWidth;
    self.txtCoreTemp.y = row;
    self.txtCoreTemp.width = "20%";
    self.txtCoreTemp.height = 1;
    self.txtCoreTemp.foreground = 0x00ff00;
    self:_addElement(self.txtCoreTemp);

    self.lblReactivity = Text:new();
    self.lblReactivity.text = "Reactivity: ";
    self.lblReactivity.textAlign = "right";
    self.lblReactivity.x = "40%";
    self.lblReactivity.y = row;
    self.lblReactivity.width = "35%";
    self.lblReactivity.height = 1;
    self.lblReactivity.foreground = 0x00ff00;
    self:_addElement(self.lblReactivity);


    self.txtReactivity = Text:new();
    self.txtReactivity.text = " - ";
    self.txtReactivity.left = "75%";
    self.txtReactivity.y = row;
    self.txtReactivity.width = "25%";
    self.txtReactivity.height = 1;
    self.txtReactivity.foreground = 0x00ff00;
    self:_addElement(self.txtReactivity);
    

    row = row + 1;

    self.lblCaseTemp = Text:new();
    self.lblCaseTemp.text = "Case: ";
    self.lblCaseTemp.textAlign = "right";
    self.lblCaseTemp.y = row;
    self.lblCaseTemp.width = colWidth;
    self.lblCaseTemp.height = 1;
    self.lblCaseTemp.foreground = 0x00ff00;
    
    self:_addElement(self.lblCaseTemp);

    self.txtCaseTemp = Text:new();
    self.txtCaseTemp.text = " - ";
    self.txtCaseTemp.left = colWidth;
    self.txtCaseTemp.y = row;
    self.txtCaseTemp.width = "50%";
    self.txtCaseTemp.height = 1;
    self.txtCaseTemp.foreground = 0x00ff00;
    self:_addElement(self.txtCaseTemp);

    row = row + 1;
    row = row + 1;

    self.lblRod = Text:new();
    self.lblRod.text = "Power: ";
    self.lblRod.textAlign = "right";
    self.lblRod.y = row;
    self.lblRod.width = colWidth;
    self.lblRod.height = 1;
    self.lblRod.foreground = 0x00ff00;
    self:_addElement(self.lblRod);
  
    self.prgRodLevel = Progressbar:new();
    self.prgRodLevel.value = 0;
    self.prgRodLevel.y = row;
    self.prgRodLevel.left = colWidth;
    self.prgRodLevel.right = 6;
    self.prgRodLevel.width = "auto";
    self.prgRodLevel.height = 1;
    self.prgRodLevel.barColor = 0xAA0000;
    self.prgRodLevel.barBgColor = 0x333333;
    self.prgRodLevel.maxValue = 1;
    --self.txtCaseTemp.foreground = 0x00ff00;
    self:_addElement(self.prgRodLevel);

    self.lblRodPercent = Text:new();
    self.lblRodPercent.text = " - ";
    self.lblRodPercent.textAlign = "right";
    self.lblRodPercent.left = "90%";
    self.lblRodPercent.y = row;
    self.lblRodPercent.width = 4;
    self.lblRodPercent.height = 1;
    self.lblRodPercent.foreground = 0x00ff00;
    self:_addElement(self.lblRodPercent);

    row = row + 1;
    row = row + 1;
    
    self.lblSteam = Text:new();
    self.lblSteam.text = "Steam: ";
    self.lblSteam.textAlign = "right";
    self.lblSteam.y = row;
    self.lblSteam.width = colWidth;
    self.lblSteam.height = 1;
    self.lblSteam.foreground = 0x00ff00;
    self:_addElement(self.lblSteam);
  
    self.prgSteam = Progressbar:new();
    self.prgSteam.value = 0;
    self.prgSteam.y = row;
    self.prgSteam.left = colWidth;
    self.prgSteam.right = 6;
    self.prgSteam.width = "auto";
    self.prgSteam.height = 1;
    self.prgSteam.barColor = 0xAAAAAA;
    self.prgSteam.barBgColor = 0x333333;
    self.prgSteam.maxValue = 1;
    self:_addElement(self.prgSteam);

    self.lblSteamPercent = Text:new();
    self.lblSteamPercent.text = " - ";
    self.lblSteamPercent.textAlign = "right";
    self.lblSteamPercent.left = "90%";
    self.lblSteamPercent.y = row;
    self.lblSteamPercent.width = 4;
    self.lblSteamPercent.height = 1;
    self.lblSteamPercent.foreground = 0x00ff00;
    self:_addElement(self.lblSteamPercent);
    
end


function ReactorStats:get_coreTemp()
    return self._coreTemp;
end

function ReactorStats:set_coreTemp(value)
    if self._coreTemp ~= value then
        self._coreTemp = value;
        self.txtCoreTemp.text = tostring(value) .. 'C';
    end
end

function ReactorStats:get_caseTemp()
    return self._caseTemp;
end

function ReactorStats:set_caseTemp(value)
    if self._caseTemp ~= value then
        self._caseTemp = value;
        self.txtCaseTemp.text = tostring(value) .. 'C';
    end
end

function ReactorStats:get_state()
    return self._state;
end

function ReactorStats:set_state(value)
    if self._state ~= value then
        self._state = value;
        if value then
            self.txtState.text =  'ON';
        else
            self.txtState.text = 'OFF';
        end
    end
end


function ReactorStats:get_rodLevelPercent()
    if self._rodLevel and self._rodLevelMax and self._rodLevelMax > 0 then
        return self._rodLevel / self._rodLevelMax;
    end
    return 0;
end

function ReactorStats:get_rodLevel()
    return self._rodLevel;
end

function ReactorStats:set_rodLevel(value)
    if self._rodLevel ~= value then
        self._rodLevel = value;
        self:_updateRodPercent();
    end
end

function ReactorStats:get_rodLevelMax()
    return self._rodLevelMax;
end

function ReactorStats:set_rodLevelMax(value)
    if self._rodLevelMax ~= value then
        self._rodLevelMax = value; 
        self:_updateRodPercent();
    end
end

function ReactorStats:_updateRodPercent()
    self.prgRodLevel.value = self.rodLevelPercent;
    local p = math.floor(self.prgRodLevel.value * 100 + 0.5);
    self.lblRodPercent.text = p .. "%";
end


function ReactorStats:get_steamProduced()
    return self._steamProduced;
end

function ReactorStats:set_steamProduced(value)
    if self._steamProduced ~= value then
        self._steamProduced = value;
        self.prgSteam.value = value / 50000;
        self.lblSteamPercent.text = math.floor(self.prgSteam.value * 100 + 0.5) .. '%';
    end
end

function ReactorStats:get_reactivity()
    return self._reactivity;
end

function ReactorStats:set_reactivity(value)
    if self._reactivity ~= value then
        self._reactivity = value;
        
        self.txtReactivity.text = math.floor(value + 0.5) .. '%';
    end
end


return ReactorStats;