local Class = import("oop/Class")
local TableUtil = import("./TableUtil");

local Average = Class("Average");

function Average:initialize(max)
    self.max = max;
    self.data = {};
end


function Average:add(value)
    table.insert(self.data, value);
    if self.max and #self.data > self.max then
        table.remove(self.data, 1);
    end
end


function Average:reset()
    self.data = {};
end

function Average:get()
    return TableUtil.sum(self.data) / #self.data;
end

return Average;