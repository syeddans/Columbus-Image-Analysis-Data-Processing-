library(dplyr)
library(forcats)

AnalysisName = "2023-10-10 BODIPY 3T3L1 bisphenols cellmask rep1-p2-june19-JC" 
path = paste0("~/storage/Columbus Processing/", AnalysisName)
path2 = paste0(path,"/")
files = list.files(path, pattern=NULL, all.files=FALSE, 
           full.names=FALSE)
plane = 1
db = data.frame()
db2 = data.frame() 
for (file in files) { 
  well <- gsub(".*\\.([A-Z0-9]+)\\[.*", "\\1", file)
  print(well)
  file_name <- paste0(path2,file)
  table <- read.table(file_name,sep="\t",header=TRUE,fill = TRUE)
  table <- table[,c(7,11,13,19)]
  colnames(table)
  if (plane >0){ 
    table <-table[table$Plane == plane, ]
  }
  
  nonZeroRows <- subset(db2, table$Nuclei...Lipid.In.Cell..Overlap.... > 2)
  
  # Get the number of rows in the subset
  numNonZeroRows <- nrow(nonZeroRows)
  db2 <- rbind(db2, c(nrow(table), numNonZeroRows, well))
  db <- rbind(db,table)
}
colnames(db) <- colnames(table)
colnames(db2) <- c("Number of Cells", "Cells with Lipid", "WellName")

db2$`Number of Cells` <- as.numeric(db2$`Number of Cells`)
db2$`Cells with Lipid` <- as.numeric(db2$`Cells with Lipid`)
sum(db2$`Number of Cells`) 
db2$"% Cells with Lipid" <- db2$`Cells with Lipid`/db2$`Number of Cells`
head(db2)
#write.table(db2, "~/storage/Jen Project/rep1-p1-june19 v3.txt", sep="\t", row.names=FALSE)
wellMapFileName = paste0(AnalysisName, "-wellmap.csv") #wellmap file name should come in as analysis file name + -wellmap

wellMap <- read.csv(paste0("~/storage/Columbus Processing/", wellMapFileName),sep =",", header = FALSE, row.names = 1)
colnames(wellMap) <- wellMap[1, ]
wellMap <- wellMap[-1, ]

combinations <- character()
for (row in rownames(wellMap)) {
  for (col in colnames(wellMap)) {
    combinations <- c(combinations, paste0(row, col))
  }
}
lookup <- data_frame(WellName =combinations) 
chemical <- character() 

for (row in seq_along(rownames(wellMap))) { 
  for (col in seq_along(colnames(wellMap))){ 
    chemical <- c(chemical, paste0(wellMap[row,col])) 
  }
}
lookup$chemical <- chemical


data = db2
datamerged <- left_join(data, lookup, by = "WellName")
#datamerged <- datamerged[datamerged$Plane == 1, ]
#datamerged <- datamerged[,-c(1,2,3,4,5,6,8,9,10,16,17)]
#datamerged <- datamerged[,-c(1,2,8,9)]
colnames(datamerged)
datamerged

datamerged$chemicalgroup <- gsub("^.*? ", "", datamerged$chemical) 


outputFileName = paste0(AnalysisName, ".txt") 
write.table(datamerged, paste0("~/storage/Columbus Processing/", outputFileName), sep="\t", row.names=FALSE)




