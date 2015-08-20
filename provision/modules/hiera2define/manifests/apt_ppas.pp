class hiera2define::apt_ppas ($ppas = {}) {
    create_resources(apt::ppa, $ppas)
}