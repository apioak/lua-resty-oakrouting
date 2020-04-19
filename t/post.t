use t::APIOAK 'no_plan';


run_tests();


__DATA__

=== TEST 1: match post method routing success

--- config
location /t {
    content_by_lua_block {
        local routing = require('resty.oakrouting')
        local oak     = routing.new()


        oak:post("/test/post", function()
            ngx.say("TEST POST REQUEST OK")
        end)


        local succeed = oak:dispatch("/test/post", "POST")
        if not succeed then
            ngx.say("TEST POST REQUEST FAIL")
        end
    }
}
--- request
GET /t
--- no_error_log
[error]
--- response_body
TEST POST REQUEST OK
