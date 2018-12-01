
local MEPowerPlantService = import("oc-ex-reactor/service/MEPowerPlant/MEPowerPlantService")


local MEPowerPlantServiceInst;

function start()
    if not MEPowerPlantServiceInst then
        MEPowerPlantServiceInst = MEPowerPlantService:new();
    end
    MEPowerPlantServiceInst:start(false);
end

function stop()
    MEPowerPlantServiceInst:stop();
end