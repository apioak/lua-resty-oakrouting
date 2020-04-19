local oakrouting   = require("resty.oakrouting")
local match_count  = 100000
local table_insert = table.insert
local match_router

local routers = {}
for i = 1, match_count do
    table_insert(routers, {
        path = "/bench/" .. ngx.md5(i),
        method = "GET",
        handler = function() end
    })
    if i == match_count then
        match_router = "/bench/" .. ngx.md5(i)
    end
end


local oak_routing = oakrouting.new(routers)


ngx.update_time()
local begin_time = ngx.now()


local succeed = oak_routing:dispatch(match_router, "GET")


ngx.update_time()
local used_time = ngx.now() - begin_time

ngx.say("matched succeed : ", succeed)
ngx.say("matched count   : ", match_count)
ngx.say("matched time    : ", used_time, " sec")
ngx.say("QPS             : ", math.floor(match_count / used_time))
