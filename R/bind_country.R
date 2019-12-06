

tt_bind_country <- function(df, type, by) {
  switch(type,
    "mof" = {
      dplyr::distinct(dplyr::select(.country_ref_list, name_ch, dplyr::contains("mof")))


    },
    "itc" = {

    },
    "wb" = {

    },
    "imf" = {

    },
    "oxford" = {

    },
    "un" = {

    },
    "gta" = {

    },
    "itc.tariff" = {

    }
  )
}

