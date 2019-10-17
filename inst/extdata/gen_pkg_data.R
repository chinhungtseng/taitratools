# TODO Adding some common

# tt_source_path data
tmp_path <- readxl::read_xlsx("inst/extdata/tt_source_path.xlsx")
tt_source_path <- as.list(tmp_path$path)
names(tt_source_path) <- tmp_path$name

# industry21 data
tmp_tbl <- tt_read_table(tt_get_path("PATH_INDUSTRY"))
tt_ind21_list <- c("001", "007", "018", "028", "033", "045", "050", "054", "058", "062",
                "078", "083", "088", "102", "105", "106", "107", "108", "110", "115",
                "120", "134", "157", "158", "174", "175", "179", "180", "184", "185",
                "189", "196", "197", "198", "199", "222", "223", "224", "225", "226",
                "227", "228", "229", "233", "234", "238", "239", "240", "241", "257",
                "263", "298", "353", "354")

tt_ind21_tbl <- tmp_tbl[tmp_tbl[["\u7DE8\u865F"]] %in% tt_ind21_list, ][c("\u7DE8\u865F", "industry")]

save(tt_source_path, tt_ind21_tbl, tt_ind21_list, file = "R/sysdata.rda")
