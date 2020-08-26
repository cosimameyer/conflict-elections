# -------------------------------------------------------------------------
# Topic: Data for ShinyApp: Electoral violence in Afghanistan
# Name: Cosima Meyer
# Date: August 2020
# -------------------------------------------------------------------------

# Load dependencies -------------------------------------------------------

packages <- c(
  "readr",
  "leaflet",
  "magrittr",
  "dplyr",
  "stringr",
  "htmlwidgets",
  "htmltools",
  "rgdal",
  "shiny",
  "knitr"
)

# Install uninstalled packages
lapply(packages[!(packages %in% installed.packages())], install.packages)

# Load all packages to library
lapply(packages, library, character.only = TRUE)

# Data --------------------------------------------------------------------

acled_afg <-
  read.csv("../data/1900-01-01-2020-03-22-Afghanistan.csv")

# Reduce the data to the required data frame
acled_afg$event_date <- as.character(acled_afg$event_date)

acled_afg %<>%
  mutate(
    year = str_extract(event_date, "[[:digit:]]{4}"),
    month = str_extract(event_date, "[[:alpha:]]{1,10}"),
    day = str_extract(event_date, "[[:digit:]]{2}"),
    date = as.Date(paste0(year, "-", month, "-", day), format = "%Y-%B-%d")
  )

# the election date: 28-09-2019
# restrict to 180 days prior to election (01-04-2019)
# and 30 days after the election (28-10-2019)
acled_afg %<>%
  filter(date >= "2019-04-01") %>%
  filter(date <= "2019-10-28")

# Restrict only to those attacks that had Taliban involvement
acled_afg %<>%
  filter(str_detect(actor1, "Taliban") == TRUE |
           str_detect(actor2, "Taliban") == TRUE)

# We could also color Taliban strongholds in 2019.
# A possible coding could be based on this
# [map](https://www.aljazeera.com/indepth/interactive/2016/08/afghanistan-controls-160823083528213.html).

# Generate time slots
acled_afg %<>%
  mutate(time_dummy = ifelse(
    date == "2019-09-28",
    1,
    ifelse(
      date < "2019-09-28" & date >= "2019-08-29",
      2,
      ifelse(
        date < "2019-08-29" & date >= "2019-07-30" ,
        3,
        ifelse(
          date < "2019-07-30" & date >= "2019-06-30",
          4,
          ifelse(
            date < "2019-06-30" & date >= "2019-05-31",
            5,
            ifelse(
              date < "2019-05-31" & date >= "2019-05-01",
              6,
              ifelse(date < "2019-05-01" &
                       date >= "2019-04-01", 7, NA)
            )
          )
        )
      )
    )
  ))


# Select only relevant data
data <- acled_afg %>%
  filter(!is.na(time_dummy)) %>%
  select(
    event_date,
    Year = year,
    Type = event_type,
    Sub_type = sub_event_type,
    Actor1 = actor1,
    Actor2 = actor2,
    admin1,
    Location = location,
    latitude,
    longitude,
    Fatalities = fatalities,
    Notes = notes,
    time_dummy,
    Date = date
  ) %>%
  mutate(
    battle = case_when(Type == "Battles" ~ Fatalities),
    explosion = case_when(Type == "Explosions/Remote violence" ~ Fatalities),
    strategic = case_when(Type == "Strategic developments" ~ Fatalities),
    civilians = case_when(Type == "Violence against civilians" ~ Fatalities)
  )

data <- data %>% mutate(time_d = ifelse(time_dummy == 1, 1,
                                        ifelse(
                                          time_dummy == 2, 2,
                                          ifelse(time_dummy == 3, 3,
                                                 ifelse(
                                                   time_dummy == 4, 4,
                                                   ifelse(time_dummy ==
                                                            5, 5,
                                                          ifelse(
                                                            time_dummy == 6, 6,
                                                            ifelse(time_dummy ==
                                                                     7, 7, 0)
                                                          ))
                                                 ))
                                        )))

data <-
  data %>% mutate(time_d_char = ifelse(
    time_dummy == 1,
    "Election",
    ifelse(
      time_dummy == 2,
      "30 days prior to election",
      ifelse(
        time_dummy == 3,
        "60 days prior to election",
        ifelse(
          time_dummy == 4,
          "90 days prior to election",
          ifelse(
            time_dummy == 5,
            "120 days prior to election",
            ifelse(
              time_dummy == 6,
              "150 days prior to election",
              ifelse(time_dummy ==
                       7, "180 days prior to election", "")
            )
          )
        )
      )
    )
  ))


vars <- c(
  "Battles" = "battle",
  "Explosions/Remote violence" = "explosion",
  "Strategic developments" = "strategic",
  "Violence against civilians" = "civilians"
)


# Save data
save(data, file = "../data/data.RData")
