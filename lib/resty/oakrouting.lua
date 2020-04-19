local type         = type
local ipairs       = ipairs
local str_sub      = string.sub
local str_len      = string.len
local str_upper    = string.upper
local tab_insert   = table.insert
local ngx_re_gsub  = ngx.re.gsub
local ngx_re_match = ngx.re.match


local ok, new_tab = pcall(require, "table.new")
if not ok then
    new_tab = function(narr, nrec)
        return {}
    end
end


local _METHODS = new_tab(0, 7)
_METHODS['GET'] = true
_METHODS['POST'] = true
_METHODS['PUT'] = true
_METHODS['DELETE'] = true
_METHODS['PATCH'] = true
_METHODS['HEAD'] = true
_METHODS['OPTIONS'] = true


local _M = { _VERSION = '0.1.0' }


local mt = { __index = _M }


local function push_router(self, path, method, handler)
    if type(path) ~= "string" then
        error("invalid argument path", 2)
    end


    if not handler or type(handler) == "nil" then
        error("missing argument handler", 2)
    end


    if not method or type(path) ~= "string" then
        error("missing argument method", 2)
    end


    method = str_upper(method)
    if not _METHODS[method] then
        error("method invalid", 2)
    end


    if not self.cached_data[method] then
        self.cached_data[method] = new_tab(10, 0)
    end


    local variables = new_tab(1, 0)
    local regexp = ngx_re_gsub(path, "(\\{[a-zA-Z0-9-_]+\\})", function(m)
        local name = str_sub(m[1], 2, str_len(m[1]) - 1)
        tab_insert(variables, name)
        return '(?P<' .. name .. '>[^/]++)'
    end, "i")


    tab_insert(self.cached_data[method], {
        path = path,
        regexp = "^" .. regexp .. "$",
        handler = handler,
        variables = variables,
    })
end


function _M.post(self, path, handler)
    push_router(self, path, "POST", handler)
end


function _M.delete(self, path, handler)
    push_router(self, path, "DELETE", handler)
end


function _M.put(self, path, handler)
    push_router(self, path, "PUT", handler)
end


function _M.get(self, path, handler)
    push_router(self, path, "GET", handler)
end


function _M.patch(self, path, handler)
    push_router(self, path, "PATCH", handler)
end


function _M.head(self, path, handler)
    push_router(self, path, "HEAD", handler)
end


function _M.options(self, path, handler)
    push_router(self, path, "OPTIONS", handler)
end


function _M.any(self, method, path, handler)
    push_router(self, path, method, handler)
end


function _M.dispatch(self, path, method, ...)
    if not method or type(path) ~= "string" then
        return nil, "missing argument method"
    end


    method = str_upper(method)
    if not _METHODS[method] then
        return nil, "method invalid"
    end


    local params = new_tab(0, 1)
    local handler

    local routers = self.cached_data[method] or new_tab(1, 0)
    for i = 1, #routers do
        local router = routers[i]
        local matched = ngx_re_match(path, router.regexp, "jo")
        if matched then
            handler = router.handler
            if #router.variables > 0 then
                for _, variable in ipairs(router.variables) do
                    params[variable] = matched[variable]
                end
            end
            handler = router.handler
            break
        end
    end


    if handler and type(handler) == "function" then
        handler(params, ...)
        return true
    end


    return nil, "not matched"
end


function _M.new(routers)
    if not routers then
        routers = new_tab(0, 0)
    end


    local router_len = #routers
    local self = setmetatable({
        cached_data = new_tab(0, router_len)
    }, mt)


    for i = 1, router_len do
        local router = routers[i]
        push_router(self, router.path, router.method, router.handler)
    end


    return self
end


return _M
