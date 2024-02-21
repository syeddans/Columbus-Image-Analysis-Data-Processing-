This script is used to find percentage of cells with lipid based on image processing done in columbus image processing
Columbus will output files by well in each plate with object properties including lipid, nucleus and cell location (if BODIPY, DAPI and CELLMASK staining is performed) -- Columbus analysis file included in repo
script will sort through data to output file with each chemical's cells with lipid percentage at each dose (chemical and dose wellmap needs to be included as csv), which can then be visuallized with preferred software
filtering of cells with less than 5 lipids due to error based on overlapping that occurs with 3T3-L1 cells. 
