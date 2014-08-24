if(!file.exists("ABBREV.xlsx")) {
  require(downloader)
  # Url at which the data set is located
  fileUrl <- "http://www.ars.usda.gov/SP2UserFiles/Place/12354500/Data/SR26/dnload/sr26abxl.zip"
  tmp <- tempfile(fileext = ".zip")
  # Download zip file
  download.file(fileUrl, tmp,mode="wb")  
  unzip(tmp)
}  
  library(XLConnect) 
  wk = loadWorkbook("ABBREV.xlsx") 
  df = readWorksheet(wk, sheet="ABBREV")

  df_names <- c("ID","Calories","Protein","TotalFat","Carbohydrate","Sodium","SaturatedFat",
                "Cholesterol","Sugar","Calcium","Iron","Potassium","VitaminC","VitaminE","VitaminD",
                "HouseholdWgt","HouseholdDesc")
#  col.names(df[,c(1,4,5,6,7,16,45,48,10,11,12,15,21,41,42,49,50)]) <- df_names

  df_subset <- df[,c(1,4,5,6,7,16,45,48,10,11,12,15,21,41,42,49,50)]
  rm(df)
  names(df_subset) <- df_names

  fg <- read.csv("http://www.ars.usda.gov/SP2UserFiles/Place/12354500/Data/SR26/asc/FD_GROUP.txt",
                 sep = "^",quote="~",stringsAsFactors=FALSE,header=FALSE,colClasses = 'character',
                 col.names=c("fdGrp","fdGrp.Desc"))
  
  fd <- read.csv("http://www.ars.usda.gov/SP2UserFiles/Place/12354500/Data/SR26/asc/FOOD_DES.txt",
                 sep = "^",quote="~",stringsAsFactors=FALSE,header=FALSE,colClasses = 'character')
  fd <- fd[,1:3]
  names(fd) <- c("ID","fdGrp","Description")
  head(fd)
  fd_detail <- merge(fd,fg)
  fd_merge <- merge(fd_detail,df_subset)
  rm(fd_detail,df_subset,fd,fg,df_names)
  saveRDS(fd_merge,"USDA.rds")
