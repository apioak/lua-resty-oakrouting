package = 'lua-resty-oakrouting'
version = 'master-1'

source = {
    url = 'git://github.com/apioak/lua-resty-oakrouting',
    tag = 'master'
}

description = {
    summary = 'The APIOAK Routing component',
    homepage = 'https://github.com/apioak/lua-resty-oakrouting',
    license = 'Apache License 2.0',
    maintainer = "Janko <shuaijinchao@gmail.com>"
}

dependencies = {
    'lua >= 5.1',
}

build = {
    type = 'builtin',
    modules = {
        ['resty.oakrouting'] = 'lib/resty/oakrouting.lua',
    }
}
