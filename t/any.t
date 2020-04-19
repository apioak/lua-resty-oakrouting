use t::APIOAK 'no_plan';


run_tests();


__DATA__

=== TEST 1: match get method routing success

--- config
location /t {
    content_by_lua_block {
        local routing = require('resty.oakrouting')
        local oak     = routing.new()


        oak:any("GET", "/test/get", function()
            ngx.say("TEST GET REQUEST OK")
        end)


        oak:any("POST", "/test/post", function()
            ngx.say("TEST POST REQUEST OK")
        end)


        oak:any("PUT", "/test/put", function()
            ngx.say("TEST PUT REQUEST OK")
        end)


        oak:any("DELETE", "/test/delete", function()
            ngx.say("TEST DELETE REQUEST OK")
        end)


        local succeed = oak:dispatch("/test/get", "GET")
        if not succeed then
            ngx.say("TEST GET REQUEST FAIL")
        end


        succeed = oak:dispatch("/test/post", "POST")
        if not succeed then
            ngx.say("TEST POST REQUEST FAIL")
        end


        succeed = oak:dispatch("/test/put", "PUT")
        if not succeed then
            ngx.say("TEST PUT REQUEST FAIL")
        end


        succeed = oak:dispatch("/test/delete", "DELETE")
        if not succeed then
            ngx.say("TEST DELETE REQUEST FAIL")
        end
    }
}
--- request
GET /t
--- no_error_log
[error]
--- response_body
TEST GET REQUEST OK
TEST POST REQUEST OK
TEST PUT REQUEST OK
TEST DELETE REQUEST OK
