import.clearCache();

--local MEPowerplantApplication = import('oc-ex-reactor/service/MEPowerPlant/MEPowerplantApplication');
local MEPowerplantApplication = import('/home/oc-ex-reactor/lib/oc-ex-reactor/service/MEPowerPlant/MEPowerplantApplication');

local app = MEPowerplantApplication:new();
app:start();