# SupportOps Decision Lab: transparent base-R verification model
# Synthetic single-skill voice queue; Erlang C assumes Poisson arrivals,
# exponential service times, no abandonment, FCFS and stationary intervals.
base_contacts <- c(70, 85, 100, 120, 135, 110, 90, 75)
interval_seconds <- 1800
base_aht_seconds <- 180

erlang_c_wait <- function(load, agents) {
  if (load <= 0) return(0)
  if (agents <= load) return(1)
  term <- 1
  total <- 1
  if (agents > 1) {
    for (k in seq_len(agents - 1)) {
      term <- term * load / k
      total <- total + term
    }
  }
  term_n <- term * load / agents
  numerator <- term_n * agents / (agents - load)
  numerator / (total + numerator)
}
service_level <- function(contacts, aht_seconds, available_agents,
                          threshold_seconds = 20, interval_seconds = 1800) {
  load <- contacts * aht_seconds / interval_seconds
  if (load == 0) return(1)
  if (available_agents <= load) return(0)
  1 - erlang_c_wait(load, available_agents) *
    exp(-(available_agents - load) * threshold_seconds / aht_seconds)
}
required_available <- function(contacts, aht_seconds, target = 0.80,
                               threshold_seconds = 20, interval_seconds = 1800) {
  load <- contacts * aht_seconds / interval_seconds
  if (load == 0) return(0)
  for (n in seq.int(floor(load) + 1, 500)) {
    if (service_level(contacts, aht_seconds, n,
                      threshold_seconds, interval_seconds) >= target) return(n)
  }
  stop('No staffing solution within 500 available agents')
}
run_scenario <- function(volume_change = 0, aht_change = 0,
                         shrinkage = .20, scheduled = 22,
                         target = .80, threshold_seconds = 20) {
  stopifnot(shrinkage >= 0, shrinkage < 1, scheduled >= 0,
            target > 0, target < 1)
  v <- round(base_contacts * (1 + volume_change))
  h <- base_aht_seconds * (1 + aht_change)
  available <- floor(scheduled * (1 - shrinkage))
  need <- vapply(v, required_available, numeric(1),
                 aht_seconds = h, target = target,
                 threshold_seconds = threshold_seconds)
  sl <- vapply(v, service_level, numeric(1),
               aht_seconds = h, available_agents = available,
               threshold_seconds = threshold_seconds)
  data.frame(interval = seq_along(v), contacts = v,
             aht_seconds = h, offered_erlangs = v*h/interval_seconds,
             available_agents = available, required_available = need,
             required_scheduled = ceiling(need / (1 - shrinkage)),
             modeled_service_level = sl,
             below_target = sl < target)
}

baseline <- run_scenario()
print(baseline)
cat('Contact-weighted modeled SL:',
    weighted.mean(baseline$modeled_service_level, baseline$contacts), '\n')
cat('Workload hours:', sum(baseline$contacts) * base_aht_seconds / 3600, '\n')
shock <- run_scenario(volume_change=.25, aht_change=.10, shrinkage=.25)
print(shock)
# Sanity checks
stopifnot(all(baseline$required_available >= floor(baseline$offered_erlangs) + 1))
stopifnot(all(baseline$required_scheduled >= baseline$required_available))
