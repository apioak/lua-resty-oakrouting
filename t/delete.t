use t::APIOAK 'no_plan';


run_tests();


__DATA__

=== TEST 1: match delete method routing success

--- config
location /t {
    content_by_lua_block {
        local routing = require('resty.oakrouting')
        local oak     = routing.new()

        oak:delete("/test/delete", function()
            ngx.say("TEST DELETE REQUEST OK")
        end)

        local succeed = oak:dispatch("/test/delete", "DELETE")
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
TEST DELETE REQUEST OK
