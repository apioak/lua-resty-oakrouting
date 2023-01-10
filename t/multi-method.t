use t::APIOAK 'no_plan';


run_tests();


__DATA__

=== TEST 1: match multi-method routing success

--- config
location /t {
    content_by_lua_block {
        local routing = require('resty.oakrouting')


        local routers = {
            {
                path = "/test/string/get",
                method = "get",
                handler = function(params) end,
                priority = 1
            },
            {
                path = "/test/string/get-post",
                method = "get,post",
                handler = function(params) end,
                priority = 1
            },
            {
                path = "/test/table/get",
                method = { "get" },
                handler = function(params) end,
                priority = 1
            },
            {
                path = "/test/table/get-post",
                method = { "get", "post" },
                handler = function(params) end,
                priority = 1
            },
        }
        local oak     = routing.new(routers)
        ngx.say("TEST MULTI-METHOD INIT OK")


        local succeed = oak:dispatch("/test/string/get", "GET")
        if not succeed then
            ngx.say("TEST STRING GET REQUEST FAIL")
        end


        local succeed = oak:dispatch("/test/string/get-post", "GET")
        if not succeed then
            ngx.say("TEST STRING GET-POST GET REQUEST FAIL")
        end


        local succeed = oak:dispatch("/test/string/get-post", "POST")
        if not succeed then
            ngx.say("TEST STRING GET-POST POST REQUEST FAIL")
        end


        local succeed = oak:dispatch("/test/table/get", "GET")
        if not succeed then
            ngx.say("TEST TABLE GET REQUEST FAIL")
        end


        local succeed = oak:dispatch("/test/table/get-post", "GET")
        if not succeed then
            ngx.say("TEST TABLE GET-POST GET REQUEST FAIL")
        end


        local succeed = oak:dispatch("/test/table/get-post", "post")
        if not succeed then
            ngx.say("TEST TABLE GET-POST POST REQUEST FAIL")
        end
    }
}
--- request
GET /t
--- no_error_log
[error]
--- response_body
TEST MULTI-METHOD INIT OK
