package = 'lua-resty-oakrouting'
version = 'master-1'

source = {
    url = 'git://github.com/apioak/lua-resty-oakrouting',
    tag = 'master'
}

description = {
    summary = 'Subtree split of the APIOAK Routing component.',
    homepage = 'https://github.com/cdbattags/lua-resty-jwt',
    license = 'Apache License 2.0',
    maintainer = "Janko <shuaijinchao@gmail.com>"
}

dependencies = {
    'lua >= 5.1',
}

build = {
    type = 'builtin',
    modules = {
        ['resty.jwt'] = 'lib/resty/oakrouter.lua',
    }
}
