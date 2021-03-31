# ShinyApp: Conflict Elections in Afghanistan in 2019

## What the project is about

[![](figures/shinyapp-conflict.png)](https://cosima-meyer.shinyapps.io/conflict-elections/)

You can access the ShinyApp [here](https://cosima-meyer.shinyapps.io/conflict-elections/). [![](https://img.shields.io/badge/Shiny-shinyapps.io-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)](https://cosima-meyer.shinyapps.io/conflict-elections/)

This project is a spin-off of a co-authored publication with [Dennis Hammerschmidt](https://github.com/dennis-hammerschmidt) that [analyzes patterns of violence during conflict elections in Afghanistan](https://www.ceeol.com/search/article-detail?id=775100) in 2005.

While the geo-spatially disaggregated data for the original publication is based on [UCDP data](https://ucdp.uu.se), this ShinyApp is based on [ACLED data](https://acleddata.com/#/dashboard) and shows how violence that includes the Taliban develops starting 180 days up to the election in 2019.

## Material

You can access the material for past talks on this ShinyApp here:
| Event                           |                                                                               |                                                                                                       |                                                          |
|---------------------------------|-------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| Research plus "Datenvisualisierung 2.0" | [Slides](https://cosimameyer.rbind.io/slides/research-plus/talk#1)   |  |                                                          |
| CorrelAid Workshop 2020 "Shiny" | [Slides](http://cosimameyer.rbind.io/slides/correlaid-workshop/talk.html#1)   | [Code](https://github.com/cosimameyer/conflict-elections/tree/master/material_CorrelAid_Workshop) |                                                          |
| CorrelCon 2020 "Talking Shiny"  | [Slides](https://cosimameyer.rbind.io/slides/correlcon/talk#1)                | [Code](https://github.com/cosimameyer/conflict-elections/tree/master/material_CorrelCon_2020)     | [Recording](https://www.youtube.com/watch?v=NOzi6GErpsA) |
| OODM 2020 "Interactive Science" | [Slides](https://cosimameyer.rbind.io/slides/interactive-science/correlaid#1) | [Code](https://github.com/cosimameyer/conflict-elections/tree/master/material_OODM_CorrelAid)     |                                                          |

## Overview repository
This repository contains: 
```
├── README.md
├── app.R
├── code
│   ├── data.R
│   ├── helper.R
│   └── theme_custom.R
├── conflict-elections.Rproj
├── data
│   ├── 1900-01-01-2020-03-22-Afghanistan.csv
│   └── data.RData
├── figures
│   └── shinyapp-conflict.png
├── markdown
│   ├── about.md
│   └── git.md
├── material_CorrelAid_Workshop
│   ├── example_ShinyApp_ggplot
│   │   └── app.R
│   ├── example_ShinyApp_shinydashboard_ggplot
│   │   └──  app.R
├── material_CorrelCon_2020
│   ├── example_ShinyApp_ggplot
│   │   └── app.R
│   ├── example_ShinyApp_shinydashboard_ggplot
│   │   └──  app.R
│   ├── example_ShinyApp_echarts4r
│   │   └── app.R
│   └── example_ShinyApp_shinydashboard_echarts4r
│       └── app.R
└── material_OODM_CorrelAid
    ├── example_ShinyApp
    │   └── app.R
    └── example_ShinyApp_shinydashboard
        └── app.R
```

## Additional input

⚡ Optimize your ShinyApp
 - [Make your ShinyApp faster](https://appsilon.com/r-shiny-faster-updateinput-css-javascript/)
 - [shiny.worker](https://www.r-bloggers.com/shiny-worker-speed-up-r-shiny-apps-by-offloading-heavy-calculations/)
  
