# Variables that can be put on the x and y axes
axis_vars <- c(
  "Protein" = "Protein",
  "TotalFat" = "TotalFat",
  "Carbohydrate" = "Carbohydrate",
  "Sodium" = "Sodium",
  "SaturatedFat" = "SaturatedFat",
  "Cholesterol" = "Cholesterol",
  "Sugar" = "Sugar",
  "Calories" = "Calories"  
  )

fg_vars <- c(
  "All"                                 = "0000",
  "Dairy and Egg Products"              = "0100" ,  
  "Spices and Herbs"                    = "0200" ,	
  "Baby Foods"                          = "0300" ,	
  "Fats and Oils"                       = "0400" ,	
  "Poultry Products"                    = "0500" ,	
  "Soups, Sauces, and Gravies"          = "0600" ,	
  "Sausages and Luncheon Meats"         = "0700" ,	
  "Breakfast Cereals"                   = "0800" ,	
  "Fruits and Fruit Juices"             = "0900" ,	
  "Pork Products"                       = "1000" ,	
  "Vegetables and Vegetable Products"   = "1100" ,	
  "Nut and Seed Products"               = "1200" ,	
  "Beef Products"                       = "1300" ,	
  "Beverages"                           = "1400" ,	
  "Finfish and Shellfish Products"      = "1500" ,	
  "Legumes and Legume Products"         = "1600" ,	
  "Lamb, Veal, and Game Products"       = "1700" ,	
  "Baked Products"                      = "1800" ,	
  "Sweets"                              = "1900" ,	
  "Cereal Grains and Pasta"             = "2000" ,	
  "Fast Foods"                          = "2100" ,	
  "Meals, Entrees, and Side Dishes"     = "2200" ,	
  "Snacks"                              = "2500" ,	
  "American Indian/Alaska Native Foods" = "3500" ,	
  "Restaurant Foods"                    = "3600" 	
  )

#setwd("C:\\Users\\matta\\Desktop\\Coursera\\Developing Data Products\\NutritionApp")
#data1 <- read.csv("USDA.csv")
#data1 <- data1[!is.na(data1$Protein),]

data1 <- readRDS("USDA.rds")

dri_min <- data.frame(Protein=50,
                      TotalFat=30,
                      Carbohydrate=30,
                      Sodium=1500,
                      SaturatedFat=mean(data1$SaturatedFat,na.rm=T)+(2*sd(data1$SaturatedFat,na.rm=T)),
                      Cholesterol=mean(data1$Cholesterol,na.rm=T)+(2*sd(data1$Cholesterol,na.rm=T)),
                      Sugar=mean(data1$Sugar,na.rm=T)+(2*sd(data1$Sugar,na.rm=T)),
                      Calories=mean(data1$Calories,na.rm=T)+(2*sd(data1$Calories,na.rm=T))
                      )
dri_max <- data.frame(Protein=56,
                      TotalFat=65,
                      Carbohydrate=37,
                      Sodium=2400,
                      SaturatedFat=mean(data1$SaturatedFat,na.rm=T)+(3*sd(data1$SaturatedFat,na.rm=T)),
                      Cholesterol=mean(data1$Cholesterol,na.rm=T)+(3*sd(data1$Cholesterol,na.rm=T)),
                      Sugar=mean(data1$Sugar,na.rm=T)+(3*sd(data1$Sugar,na.rm=T)),
                      Calories=mean(data1$Calories,na.rm=T)+(2*sd(data1$Calories,na.rm=T))
                      )

#all <- complete.cases(data1)
data1$High_Dri = c(rep(FALSE, nrow(data1)))

#data1[(all & (data1$Protein > dri_max$Protein)),"High_Dri"] <- "TRUE"

#data1[(all & (data1$Carbohydrate > dri_max$Carbohydrate)),"High_Dri"] <- "TRUE"

#data1[(all & (data1$TotalFat > dri_max$TotalFat)),"High_Dri"] <- "TRUE"

#data1$High_Dri <- data1[,(
#                          (data1$Protein > dri_max$Protein) ||  
#                          (data1$TotalFat > dri_max$TotalFat) ||
#                          (data1$Carbohydrate > dri_max$Carbohydrate)
#                          )]

