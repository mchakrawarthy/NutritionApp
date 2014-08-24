library(ggvis)
library(googleVis)

shinyServer(function(input, output, session) {
  max_rows <- nrow(data1)
  values <- reactiveValues(selected = rep(TRUE, max_rows))
  usda <- reactive({
    max_rows <- nrow(data1)
    values <- reactiveValues(selected = rep(TRUE, max_rows))
    data1$High_Dri = c(rep(FALSE, max_rows))
    fg <- input$fg
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    if (fg == '0000') {
      select = !is.na(data1[,xvar_name]) & !is.na(data1[,yvar_name])            
    } else {
      select = data1$fdGrp %in% fg & !is.na(data1[,xvar_name]) & !is.na(data1[,yvar_name])
    }
    df <- data1[select,]
    
    # Optional: filter by description
    if (!is.null(input$description) && input$description != "") {
      description <- input$description   
      df <- df[grepl(description,df$Description,ignore.case=TRUE) & !is.na(df$ID),] 
    }
    
    high_nutrition <- (df[,xvar_name] > dri_max[,xvar_name]) | (df[,yvar_name] > dri_max[,yvar_name])
    if (length(high_nutrition) > 0) {
      df[high_nutrition,"High_Dri"] <- "TRUE"
    }
    rm(high_nutrition)
    df
    
  })
  
  # Function for generating tooltip text
  usda_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$ID)) return(NULL)
    # Pick out the movie with this ID
    df <- isolate(usda())
    usda <- df[df$ID == x$ID, ]
    
    paste0("<b>", usda$Description, "</b>,<br>", "Gram Weight: ",
           usda$HouseholdWgt, "&nbsp", "Weight Description: ","&nbsp",
           usda$HouseholdDesc, "<br>", input$xvar,":","&nbsp",
           usda[,input$xvar],  "&nbsp", input$yvar,":","&nbsp",
           usda[,input$yvar]
    )
  }
  
  # A reactive expression with the ggvis plot
  vis <- reactive({
    # Lables for axes
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))
    
    
    usda %>%
      ggvis(x = xvar
            , y = yvar
      ) %>%
      layer_points(size := 50, size.hover := 100,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5, fill.hover := "orange",
                   stroke = ~High_Dri, 
                   key := ~ID) %>%
      handle_click(function(data, ...) {
        xvar_name <- names(axis_vars)[axis_vars == input$xvar]
        yvar_name <- names(axis_vars)[axis_vars == input$yvar]
        if (!xvar_name %in% names(data)) return(NULL)
        if (!yvar_name %in% names(data)) return(NULL)
        values$selected <- usda()[,xvar_name] == data[,xvar_name] & usda()[,yvar_name] == data[,yvar_name]
      }) %>%
      add_tooltip(usda_tooltip, "hover") %>%
      add_axis("x", title = xvar_name) %>%
      add_axis("y", title = yvar_name) %>%
      add_legend("stroke", title = "Higher than Daily Avg", values = c("TRUE", "FALSE"),
                 properties = legend_props(
                   title = list(fontSize = 10),
                   labels = list(fontSize = 8, dx = 5))
      )%>%
      scale_nominal("stroke", domain = c("TRUE", "FALSE"),
                    range = c("red", "#aaa")) %>%
      set_options(width = 400, height = 400)  
  })
  
  vis %>% bind_shiny("plot1")
  
  selected <- reactive({ 
    
    usda()[values$selected, , drop = FALSE] 
  })
  
  datasetInputx <- reactive({    
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]  
    if (is.null(selected())) return(NULL)
    df <- data.frame(Label = xvar_name, Value = selected()[1,xvar_name])
    df
  })
  datasetInputy <- reactive({        
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    if (is.null(selected())) return(NULL)         
    df <- data.frame(Label = yvar_name, Value = selected()[1,yvar_name])
    df
  })
  
  myOptionsx <- reactive({
    
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    list(animation.duration=800,animation.easing='linear',
         width=200, height=200,
         min=0, 
         max=ceiling(max(data1[,xvar_name],na.rm = T)), 
         greenFrom=0, 
         greenTo=ceiling(dri_min[,xvar_name]), 
         yellowFrom=ceiling(dri_min[,xvar_name]), 
         yellowTo=ceiling(dri_max[,xvar_name]),
         redFrom=ceiling(dri_max[,xvar_name]), 
         redTo=ceiling(max(data1[,xvar_name],na.rm = T))
    )
  })
  myOptionsy <- reactive({
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    list(animation.duration=800,animation.easing='linear',
         width=200, height=200,
         min=0, 
         max=ceiling(max(data1[,yvar_name],na.rm = T)), 
         greenFrom=0, 
         greenTo=ceiling(dri_min[,yvar_name]), 
         yellowFrom=ceiling(dri_min[,yvar_name]), 
         yellowTo=ceiling(dri_max[,yvar_name]),
         redFrom=ceiling(dri_max[,yvar_name]), 
         redTo=ceiling(max(data1[,yvar_name],na.rm = T))
    )
  })
  
  
  output$viewx <- renderGvis({ 
    if (is.null(datasetInputx())) return(NULL)
    if (is.null(datasetInputx()[1,1])) return(NULL)
    if (nrow(selected()) == max_rows) return(NULL)
    #    if (!nrow(datasetInputx()) == 1) return(NULL)    
    
    gvisGauge(datasetInputx()[1,], options=myOptionsx())
  })    
  
  output$viewy <- renderGvis({ 
    if (is.null(datasetInputy())) return(NULL)
    if (is.null(datasetInputy()[1,1])) return(NULL)  
    if (nrow(selected()) == max_rows) return(NULL)
    #    if (!nrow(datasetInputy()) == 1) return(NULL) 
    
    gvisGauge(datasetInputy()[1,], options=myOptionsy())
  })    
  
  output$text1 <- renderText({ 
    
    if (!nrow(selected()) == max_rows) {
      paste(selected()[1,"Description"])
    } else {
      paste("Select point on the Chart to explore")
    }
    
  })
  
  output$details <- renderGvis({
    
    if (!nrow(selected()) == max_rows) {
      df <- selected()[!is.na(1),c(-1,-2,-21,-13:-18)]
      names(df)[c(1,2,11,12)] <- c("Food Description", "Food Group","Gram Weight","Weight Description")
      gvisTable(df)
    }
    
  })
  
  
  output$table <- renderDataTable({
        data1[,c(-1,-2,-21,-13:-18)]}, options = list(bFilter = TRUE, iDisplayLength = 50))
  })