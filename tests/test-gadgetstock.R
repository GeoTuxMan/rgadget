library(Rgadget)
library(unittest, quietly = TRUE)
library(magrittr)
source('utils/helpers.R')

ver_string <- paste("; Generated by Rgadget", packageVersion("Rgadget"))

# Write string into temporary directory and read it back again as a gadget file
read.gadget.string <- function(..., file_type = "generic") {
    dir <- tempfile()
    dir.create(dir)
    writeLines(c(...), con = file.path(dir, "wibble"))
    read.gadget.file(dir, "wibble", file_type = file_type)
}

ok_group("Can create new stocks with some default content", {
    path <- tempfile()

    gadgetstock('codimm', path, missingOkay = TRUE) %>%  # Create a skeleton if missing
        gadget_update('stock', minage = 2, maxage = 4) %>%
        gadget_update('doeseat', maxconsumption = 100, halffeedingvalue = 70) %>%
        gadget_update('doesrenew', minlength = 2, maxlength = 4, dl = 1) %>%
        write.gadget.file(path)
    ok(cmp(dir_list(path), list(
        codimm = c(
            ver_string,
            "stockname\tcodimm",
            "livesonareas\t",
            "minage\t2",
            "maxage\t4",
            "minlength\t",
            "maxlength\t",
            "dl\t",
            "refweightfile\t",
            "growthandeatlengths\t",
            "doesgrow\t0", "naturalmortality\t0", "iseaten\t0",
            "doeseat\t1", "maxconsumption\t100", "halffeedingvalue\t70",
            "initialconditions",
            "doesmigrate\t0", "doesmature\t0", "doesmove\t0",
            "doesrenew\t1", "minlength\t2", "maxlength\t4", "dl\t1",
            "doesspawn\t0", "doesstray\t0",
        NULL),
        main = c(
            ver_string,
            "timefile\t",
            "areafile\t",
            "printfiles\t; Required comment",
            "[stock]",
            "stockfiles\tcodimm",
            "[tagging]",
            "[otherfood]",
            "[fleet]",
            "[likelihood]",
        NULL)
    )), "Wrote out stock file")

    gadgetstock('codimm', path, missingOkay = FALSE) %>%
        gadget_update('stock', maxage = 6, minlength = 10, maxlength = 20) %>%
        gadget_update('doesrenew', 0) %>% # Doesn't renew anymore
        write.gadget.file(path)
    ok(cmp(dir_list(path), list(
        codimm = c(
            ver_string,
            "stockname\tcodimm",
            "livesonareas\t",
            "minage\t2",
            "maxage\t6",
            "minlength\t10",
            "maxlength\t20",
            "dl\t",
            "refweightfile\t",
            "growthandeatlengths\t",
            "doesgrow\t0", "naturalmortality\t0", "iseaten\t0",
            "doeseat\t1", "maxconsumption\t100", "halffeedingvalue\t70",
            "initialconditions",
            "doesmigrate\t0", "doesmature\t0", "doesmove\t0",
            "doesrenew\t0", "doesspawn\t0", "doesstray\t0",
        NULL),
        main = c(
            ver_string,
            "timefile\t",
            "areafile\t",
            "printfiles\t; Required comment",
            "[stock]",
            "stockfiles\tcodimm",
            "[tagging]",
            "[otherfood]",
            "[fleet]",
            "[likelihood]",
        NULL)
    )), "Updated existing stock file")

    gadgetstock('codmat', path, missingOkay = TRUE) %>%
        write.gadget.file(path)
    ok(cmp(dir_list(path), list(
        codimm = c(
            ver_string,
            "stockname\tcodimm",
            "livesonareas\t",
            "minage\t2",
            "maxage\t6",
            "minlength\t10",
            "maxlength\t20",
            "dl\t",
            "refweightfile\t",
            "growthandeatlengths\t",
            "doesgrow\t0", "naturalmortality\t0", "iseaten\t0",
            "doeseat\t1", "maxconsumption\t100", "halffeedingvalue\t70",
            "initialconditions",
            "doesmigrate\t0", "doesmature\t0", "doesmove\t0",
            "doesrenew\t0", "doesspawn\t0", "doesstray\t0",
        NULL),
        codmat = c(
            ver_string,
            "stockname\tcodmat",
            "livesonareas\t",
            "minage\t",
            "maxage\t",
            "minlength\t",
            "maxlength\t",
            "dl\t",
            "refweightfile\t",
            "growthandeatlengths\t",
            "doesgrow\t0", "naturalmortality\t0", "iseaten\t0", "doeseat\t0",
            "initialconditions",
            "doesmigrate\t0", "doesmature\t0", "doesmove\t0",
            "doesrenew\t0", "doesspawn\t0", "doesstray\t0",
        NULL),
        main = c(
            ver_string,
            "timefile\t",
            "areafile\t",
            "printfiles\t; Required comment",
            "[stock]",
            "stockfiles\tcodimm\tcodmat",
            "[tagging]",
            "[otherfood]",
            "[fleet]",
            "[likelihood]",
        NULL)
    )), "Added new stock file, left old one alone")

    gadgetstock('codmat', path, missingOkay = TRUE) %>%
        gadget_update('doesmigrate', 
            yearstepfile = gadgetfile('data/yearstepfile', components = list(
                data.frame(year = 1998, step = 1:4, matrix = 'codmat-migration'))),
            definematrices = gadgetfile('data/migratematrix', components = list(
                migrationmatrix = list(name = 'codmat-migration'),
                data.frame(1:4, 1:4, 1:4, 1:4)))) %>%
        write.gadget.file(path)
    ok(cmp(dir_list(path), list(
        codimm = c(
            ver_string,
            "stockname\tcodimm",
            "livesonareas\t",
            "minage\t2",
            "maxage\t6",
            "minlength\t10",
            "maxlength\t20",
            "dl\t",
            "refweightfile\t",
            "growthandeatlengths\t",
            "doesgrow\t0", "naturalmortality\t0", "iseaten\t0",
            "doeseat\t1", "maxconsumption\t100", "halffeedingvalue\t70",
            "initialconditions",
            "doesmigrate\t0", "doesmature\t0", "doesmove\t0",
            "doesrenew\t0", "doesspawn\t0", "doesstray\t0",
        NULL),
        codmat = c(
            ver_string,
            "stockname\tcodmat",
            "livesonareas\t",
            "minage\t",
            "maxage\t",
            "minlength\t",
            "maxlength\t",
            "dl\t",
            "refweightfile\t",
            "growthandeatlengths\t",
            "doesgrow\t0", "naturalmortality\t0", "iseaten\t0", "doeseat\t0",
            "initialconditions",
            "doesmigrate\t1", "yearstepfile\tdata/yearstepfile", "definematrices\tdata/migratematrix",
            "doesmature\t0", "doesmove\t0",
            "doesrenew\t0", "doesspawn\t0", "doesstray\t0",
        NULL),
        "data/migratematrix" = c(
            ver_string,
            "[migrationmatrix]",
            "name\tcodmat-migration",
            "; -- data --",
            "; X1.4\tX1.4.1\tX1.4.2\tX1.4.3",
            "1\t1\t1\t1",
            "2\t2\t2\t2",
            "3\t3\t3\t3",
            "4\t4\t4\t4",
        NULL),
        "data/yearstepfile" = c(
            ver_string,
            "; -- data --",
            "; year\tstep\tmatrix",
            "1998\t1\tcodmat-migration",
            "1998\t2\tcodmat-migration",
            "1998\t3\tcodmat-migration",
            "1998\t4\tcodmat-migration",
        NULL),
        main = c(
            ver_string,
            "timefile\t",
            "areafile\t",
            "printfiles\t; Required comment",
            "[stock]",
            "stockfiles\tcodimm\tcodmat",
            "[tagging]",
            "[otherfood]",
            "[fleet]",
            "[likelihood]",
        NULL)
    )), "Added new stock file, left old one alone")
})

# TODO: Tests for mfdb-derived data