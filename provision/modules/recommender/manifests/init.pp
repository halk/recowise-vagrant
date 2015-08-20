class recommender {

    include recommender::install
    include recommender::api
    include recommender::celery
    include recommender::flower
    include recommender::engines
}
