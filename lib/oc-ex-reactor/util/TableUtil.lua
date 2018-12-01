local TableUtil = {};

TableUtil.reduce = function(tbl, reduceFn)
    local acc;
    for k, v in ipairs(tbl) do
        if k == 1 then
            acc = v;
        else
            acc = reduceFn(acc, v);
        end 
    end 
    return acc;
end


TableUtil.sum = function(tbl)
    return TableUtil.reduce(tbl, function(a, b)
        return a + b;
    end)
end

TableUtil.avg = function(tbl)
    return TableUtil.sum(tbl) / #tbl;
end

return TableUtil;