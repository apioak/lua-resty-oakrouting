use t::APIOAK 'no_plan';


run_tests();


__DATA__

=== TEST 1: match put method routing

--- config
location /t {
    content_by_lua_block {
        local routing = require('resty.oakrouting')
        local oak     = routing.new()

        local oak_routing = routing.new({
            {
                path   = "/test/put",
                method = "PUT",
                handler = function()
                    ngx.say("TEST PUT REQUEST OK")
                end
            }
        })

        local succeed = oak_routing:dispatch("/test/put", "PUT")
        if not succeed then
            ngx.say("TEST PUT REQUEST FAIL")
        end
    }
}
--- request
GET /t
--- no_error_log
[error]
--- response_body
TEST PUT REQUEST OK
