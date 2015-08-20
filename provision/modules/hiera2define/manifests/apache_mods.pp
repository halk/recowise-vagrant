class hiera2define::apache_mods ($mods = {}) {
    create_resources(apache::mod, $mods)
}