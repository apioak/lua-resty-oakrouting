use t::APIOAK 'no_plan';


run_tests();


__DATA__

=== TEST 1: match wildcard routing success

--- config
location /t {
    content_by_lua_block {
        local routing = require('resty.oakrouting')
        local oak     = routing.new()


        oak:get("/wildcard-params/{name}/*", function(params)
            ngx.say("TEST GET REQUEST WILDCARD-PARAMS OK, PARAM IS " .. params.name)
        end)


        oak:get("/wildcard/*", function(params)
            ngx.say("TEST GET REQUEST WILDCARD OK")
        end)


        oak:get("/wildcard-end/*/end", function(params)
            ngx.say("TEST GET REQUEST WILDCARD-END OK")
        end)


        oak:get("/end-wildcard/*/wildcard-in/*", function(params)
            ngx.say("TEST GET REQUEST END-WILDCARD OK")
        end)


        local succeed = oak:dispatch("/wildcard-params/APIOAK/test", "GET")
        if not succeed then
            ngx.say("TEST GET REQUEST WILDCARD-PARAMS FAIL")
        end


        local succeed = oak:dispatch("/wildcard/APIOAK", "GET")
        if not succeed then
            ngx.say("TEST GET REQUEST WILDCARD FAIL")
        end


        local succeed = oak:dispatch("/wildcard/APIOAK/test", "GET")
        if not succeed then
            ngx.say("TEST GET REQUEST WILDCARD-TEST FAIL")
        end


        local succeed = oak:dispatch("/wildcard-end/APIOAK/end", "GET")
        if not succeed then
            ngx.say("TEST GET REQUEST WILDCARD-END FAIL")
        end


        local succeed = oak:dispatch("/wildcard-end/APIOAK/in-test/end", "GET")
        if not succeed then
            ngx.say("TEST GET REQUEST WILDCARD-END IN-TEST FAIL")
        end


        local succeed = oak:dispatch("/end-wildcard/APIOAK/wildcard-in/test", "GET")
        if not succeed then
            ngx.say("TEST GET REQUEST WILDCARD-END IN-END-1 FAIL")
        end


        local succeed = oak:dispatch("/end-wildcard/APIOAK/IN/wildcard-in/test/end", "GET")
        if not succeed then
            ngx.say("TEST GET REQUEST WILDCARD-END IN-END-2 FAIL")
        end

    }
}
--- request
GET /t
--- no_error_log
[error]
--- response_body
TEST GET REQUEST WILDCARD-PARAMS OK, PARAM IS APIOAK
TEST GET REQUEST WILDCARD OK
TEST GET REQUEST WILDCARD OK
TEST GET REQUEST WILDCARD-END OK
TEST GET REQUEST WILDCARD-END OK
TEST GET REQUEST END-WILDCARD OK
TEST GET REQUEST END-WILDCARD OK

