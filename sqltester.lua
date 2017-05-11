local json = require('json')

function finish_test()
    os.exit()
end

function do_test(label, func)
    local ok, result = pcall(func)
    if ok then
       print(label, json.encode(result))
    else
        io.stderr:write(string.format('%s\t%s\n', label, result))
    end
end

function do_catchsql_test(label, sql)
    return do_test(label, function() return catchsql(sql) end)
end

function do_catchsql2_test(label, sql)
    return do_test(label, function() return catchsql2(sql) end)
end

function do_execsql_test(label, sql)
    return do_test(label, function() return execsql(sql) end)
end

function do_execsql2_test(label, sql)
    return do_test(label, function() return execsql2(sql) end)
end

function execsql(sql)
    local result = box.sql.execute(sql)
    if type(result) ~= 'table' then return end
    for _, tuple in ipairs(result) do
        -- shift fields right, revealing typestr
        for i = #tuple,0,-1 do
            tuple[i+1] = tuple[i]
        end
        tuple[0] = nil
    end
    return result
end

function execsql2(sql)
    local result = execsql(sql)
    if type(result) ~= 'table' then return end
    -- shift rows down, revealing column names
    for i = #result,0,-1 do
        result[i+1] = result[i]
    end
    local colnames = result[1]
    for i,colname in ipairs(colnames) do
        colnames[i] = colname:gsub('^sqlite_sq_[0-9a-fA-F]+','sqlite_subquery')
    end
    result[0] = nil
    return result
end

function sortsql(sql)
    local result = execsql(sql)
    table.sort(result, function(a,b) return a[2] < b[2] end)
    return result
end

function catchsql(sql)
    return {pcall(execsql, sql)}
end

function catchsql2(sql)
    return {pcall(execsql2, sql)}
end

function db(cmd, ...)
    if cmd == 'eval' then
        return box.sql.execute(...)
    end
end

function capable()
    return true
end

setmetatable(_G, nil)
os.execute("rm -f *.snap *.xlog*")
-- start the database
box.cfg()
