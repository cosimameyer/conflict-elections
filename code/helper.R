# -------------------------------------------------------------------------
# Topic:
# Name:
# Date:
# -------------------------------------------------------------------------

# This code is based on: https://jkunst.com/blog/posts/2020-06-26-valuebox-and-sparklines/

# -------------------------------------------------------------------------
valueBoxSpark <-
  function(value,
           title,
           sparkobj = NULL,
           subtitle = NULL,
           info = NULL,
           icon = NULL,
           color = "aqua",
           width = 1,
           href = NULL) {
    shinydashboard:::validateColor(color)
    
    if (!is.null(icon))
      shinydashboard:::tagAssert(icon, type = "i")
    
    info_icon <- tags$small(
      tags$i(
        class = "fa fa-info-circle fa-lg",
        title = info,
        `data-toggle` = "tooltip",
        style = "color: rgba(255, 255, 255, 0.75);"
      ),
      # bs3 pull-right
      # bs4 float-right
      class = "pull-right float-right"
    )
    
    boxContent <- div(
      class = paste0("small-box bg-", color),
      div(
        class = "inner",
        tags$small(subtitle),
        p(title),
        if (!is.null(sparkobj))
          info_icon,
        h2(value),
        if (!is.null(sparkobj))
          sparkobj
      ),
      # bs3 icon-large
      # bs4 icon
      if (!is.null(icon))
        div(class = "icon-large icon", icon, style = "z-index; 0")
    )
    
    if (!is.null(href))
      boxContent <- a(href = href, boxContent)
    
    div(class = if (!is.null(width))
      paste0("col-sm-", width),
      boxContent)
  }
