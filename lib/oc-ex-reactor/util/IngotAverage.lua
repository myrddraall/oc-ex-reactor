local Class = import("oop/Class")
local TableUtil = import("./TableUtil");
local IngotAverage = Class("IngotAverage");

local computer = require("computer");

function IngotAverage:initialize()
    self.max = 32;
    self.data = {};
end


function IngotAverage:added()
    table.insert(self.data, 1, computer.uptime());
    if self.max and #self.data > self.max then
        table.remove(self.data, #self.data - 1);
    end
end

function IngotAverage:get(averageOverLast)
    if not averageOverLast or averageOverLast < 1 then
        if #self.data < 1 then
            return -1;
        end 
        return computer.uptime() - self.data[1];
    else
        local lastTime = self.data[1];
        local startIdx = averageOverLast + 1;
        if startIdx > #self.data then
            return -1;
        end
        local startTime = self.data[startIdx];
        
        local time = lastTime - startTime;

        return time / averageOverLast;
    end

end

return IngotAverage;