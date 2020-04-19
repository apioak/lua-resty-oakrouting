package t::APIOAK;

use Test::Nginx::Socket::Lua::Stream -Base;

repeat_each(2);
no_long_string();
no_shuffle();

my $pwd = `pwd`;
chomp $pwd;

add_block_preprocessor(sub {
    my ($block) = @_;

    my $http_config = $block->http_config // '';
    $http_config = <<_EOC_;
    lua_package_path '$pwd/lib/?.lua;;';
    $http_config
_EOC_

    $block->set_value("http_config", $http_config);
});

1;
