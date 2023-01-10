Name
====

lua-resty-oakrouting - The APIOAK Routing component


Table of Contents
=================

* [Name](#name)
* [Methods](#methods)
    * [new](#new)
    * [get](#get)
    * [post](#post)
    * [put](#put)
    * [delete](#delete)
    * [any](#any)
    * [dispatch](#dispatch)


Synopsis
========

```lua
location / {
    content_by_lua_block {
        local oakrouting  = require("resty.oakrouting")
        local oak_routing = oakrouting.new({
            {
                path = "/test/get",
                method = "GET",
                handler = function()
                    ngx.say("hello, GET")
                end,
                priority = 1,
            },
            {
                path = "/test/get/post",
                method = "GET,POST",
                handler = function()
                    ngx.say("hello, POST")
                end,
                priority = 1,
            },
            {
                path = "/test/put",
                method = { "PUT" },
                handler = function()
                    ngx.say("hello, PUT")
                end,
                priority = 1,
            },
            {
                path = "/test/put/delete",
                method = { "PUT", "DELETE" },
                handler = function()
                    ngx.say("hello, DELETE")
                end,
                priority = 1,
            },
            {
                path = "/test/parameter/{gateway}",
                method = "GET",
                handler = function(params)
                    ngx.say("hello, " .. params.gateway)
                end,
                priority = 1,
            },
            {
              path = "/test/parameter-wildcard/{gateway}/*",
              method = { "GET", "DELETE" },
              handler = function(params)
                ngx.say("hello, " .. params.gateway)
              end,
              priority = 1,
            },
        })
        
        
        local succeed = oak:dispatch("/test/get", "GET")
        if not succeed then
            ngx.say("Matched URI: /test/get FAIL")
        end


        succeed = oak:dispatch("/test/post", "POST")
        if not succeed then
            ngx.say("Matched URI: /test/post FAIL")
        end


        succeed = oak:dispatch("/test/put", "PUT")
        if not succeed then
            ngx.say("Matched URI: /test/put FAIL")
        end


        succeed = oak:dispatch("/test/delete", "DELETE")
        if not succeed then
            ngx.say("Matched URI: /test/delete FAIL")
        end
        
        succeed = oak:dispatch("/test/parameter/apioak", "GET")
        if not succeed then
            ngx.say("Matched URI: /test/parameter/apioak FAIL")
        end

        succeed = oak:dispatch("/test/parameter-wildcard/apioak/test-wildcard", "GET")
        if not succeed then
          ngx.say("Matched URI: /test/parameter-wildcard/apioak/test-wildcard FAIL")
        end
    }
}
```


Methods
=======

new
---
`syntax: res, err = oakrouting:new(routers)`

Create and initialize a routing object.

get
---
`syntax: oakrouting:get(path, handler)`

Added `GET` method routing.

post
----
`syntax: oakrouting:post(path, handler)`

Added `POST` method routing.

put
---
`syntax: oakrouting:put(path, handler)`

Added `PUT` method routing.

delete
------
`syntax: oakrouting:delete(path, handler)`

Added `DELETE` method routing.

any
---
`syntax: oakrouting:any(method, path, handler)`

Added custom routing.

dispatch
--------
`syntax: succeed = oakrouting:dispatch(path, method)`

Match the routing path and execute the handle.


Installation
============

> Installation via LuaRocks

```shell
sudo luarocks install lua-resty-oakrouting
```

