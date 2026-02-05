# I obtained some data from the NHS Digital Artificial Data Service
# https://digital.nhs.uk/services/artificial-data
# The column keys and their meanings are available in
# https://digital.nhs.uk/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hospital-episode-statistics-data-dictionary
# I did some exploratory analysis to get some values to simulate data
# The code below simulates some tables for the course materials

library(tidyverse)

setwd("hospital_records")
write_lines("*", ".gitignore")

# probabilities for location types
locations <- c("Home" = 0.02, 
               "Work" = 0.35, 
               "Educational establishment" = 0.32, 
               "Public place" = 0.20, 
               "Other" = 0.08, 
               "Not known" = 0.03)

# probabilities for diagnosis categories
diagnosis <- c(
  "Diagnosis not classifiable" = 0.01,
  "Soft tissue inflammation" = 0.01,
  "Contusion/abrasion" = 0.01,
  "Sprain/ligament injury" = 0.01,
  "Respiratory conditions" = 0.01,
  "Ophthalmological conditions" = 0.02,
  "ENT conditions" = 0.04,
  "Foreign body" = 0.01,
  "Dislocation/fracture/joint injury/amputation" = 0.00,
  "Obstetric conditions" = 0.23,
  "Nothing abnormal detected" = 0.02,
  "Gastrointestinal conditions" = 0.03,
  "Laceration" = 0.00,
  "Psychiatric conditions" = 0.01,
  "Head injury" = 0.02,
  "Muscle/tendon injury" = 0.03,
  "Social problems (inc chronic alcoholism and homelessness)" = 0.02,
  "Urological conditions (inc cystitis)" = 0.01,
  "Local infection" = 0.02,
  "Infectious disease" = 0.00,
  "Cerebro-vascular conditions" = 0.08,
  "Gynaecological conditions" = 0.03,
  "Other vascular conditions" = 0.03,
  "Allergy (inc anaphylaxis)" = 0.00,
  "Cardiac conditions" = 0.00,
  "Dermatological conditions" = 0.06,
  "Diabetes and other endocrinological conditions" = 0.00,
  "Bites/stings" = 0.05,
  "Poisoning (inc overdose)" = 0.01,
  "Facio-maxillary conditions" = 0.01,
  "Central nervous system conditions (exc stroke)" = 0.02,
  "Burns and scalds" = 0.01,
  "Haematological conditions" = 0.01,
  "Electric shock" = 0.00,
  "Visceral injury" = 0.06,
  "Septicaemia" = 0.08,
  "Vascular injury" = 0.04,
  "Nerve injury" = 0.00,
  "Near drowning" = 0.00
)

# parameters for lognormal distribution for duration of stay (in minutes)
duration <- c("mean" = 5, "sd" = 0.8)

# function to simulate data
sim_data <- function(n = 10){
  tibble(
    location_type = sample(names(locations), n, replace = TRUE, prob = locations),
    diagnosis = sample(names(diagnosis), n, replace = TRUE, prob = diagnosis),
    duration_min = round(rlnorm(n, meanlog = duration["mean"], sdlog = duration["sd"]))
  )
}

# combination of values to simulate realistic data
# the regions are based on the NHS England regions codes
year_region <- crossing(region = c("Y56", "Y59", "Y58", 
                                   "Y60", "Y63", "Y61", "Y62"),
                        year = 2005:2025)

# simulate some data
set.seed(123)

walk2(year_region$region, year_region$year, \(region, year){
  sim_data(sample(5000:10000, 1)) |>
    mutate(year = year, 
           region = region) |>
    select(year, region, everything()) |>
    write_tsv(paste0("sim_ae_data_", year, "_", region, ".tsv"))
})
