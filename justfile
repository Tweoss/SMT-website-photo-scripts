list:
    just --list

# If these fail (bad utf8), just manually unzip some other way
unzip:
    unzip -oj "source_data/SMT headshots [website]-20241217T040715Z-001.zip" -d output/serious
    unzip -oj "source_data/SMT website silly profile image (File responses)-20241217T041410Z-001.zip" -d output/silly

resize-silly:
    ./scripts/rescale.nu

filter:
    ./scripts/filter.nu

all:
    just unzip
    just resize-silly
    just filter
