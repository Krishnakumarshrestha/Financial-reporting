source("create fake data.R")



df<- readr::read_csv("financials.csv")


date1<- "2019-01"
final <-  df %>% 
  filter(date==date1 & branch == "fargo") %>% 
  
  dplyr::rename('Branch' = branch,
                'Loans & Leases' = loans_leases,
                'Debt Securities' = debt_sec,
                'Other Interest Income' = other_int_income,
                'Deposits' = deposits,
                'Long-term Debt' = long_term_debt,
                'Card Income' = card_income,
                'Service Charges' = svc_charges,
                'Personnel' = personnel,
                'Occupancy' = occupancy,
                'Marketing' = marketing) %>% 
  dplyr::mutate(`Total Interest Income` = `Loans & Leases` + `Debt Securities` + `Other Interest Income`,
                `Total Interest Expense` = Deposits + `Long-term Debt`,
                `Net Interest Income` = `Total Interest Income` - `Total Interest Expense`,
                `Total Noninterest Income` = `Card Income` + `Service Charges`,
                `Total Revenue, Net of Interest Income` = `Total Noninterest Income` + `Net Interest Income`,
                `Total Noninterest Expense` = Personnel + Occupancy + Marketing,
                `Net Income` = `Total Revenue, Net of Interest Income` - `Total Noninterest Expense`) %>% 
  
  dplyr::mutate_if(.predicate = is.numeric, scales::dollar) %>% 
  dplyr::select('Loans & Leases','Debt Securities', 'Other Interest Income', 'Total Interest Income',
                'Deposits', 'Long-term Debt', 'Total Interest Expense', 'Net Interest Income',
                'Card Income', 'Service Charges', 'Total Noninterest Income',
                'Total Revenue, Net of Interest Income',
                'Personnel', 'Occupancy', 'Marketing', 'Total Noninterest Expense',
                'Net Income') %>%data.table::transpose(keep.names = "Fields")





final1 <- df %>% 
  dplyr::group_by(date) %>% 
  dplyr::rename('Branch' = branch,
                'Loans & Leases' = loans_leases,
                'Debt Securities' = debt_sec,
                'Other Interest Income' = other_int_income,
                'Deposits' = deposits,
                'Long-term Debt' = long_term_debt,
                'Card Income' = card_income,
                'Service Charges' = svc_charges,
                'Personnel' = personnel,
                'Occupancy' = occupancy,
                'Marketing' = marketing) %>% 
  dplyr::mutate(`Total Interest Income` = `Loans & Leases` + `Debt Securities` + `Other Interest Income`,
                `Total Interest Expense` = Deposits + `Long-term Debt`,
                `Net Interest Income` = `Total Interest Income` - `Total Interest Expense`,
                `Total Noninterest Income` = `Card Income` + `Service Charges`,
                `Total Revenue, Net of Interest Income` = `Total Noninterest Income` + `Net Interest Income`,
                `Total Noninterest Expense` = Personnel + Occupancy + Marketing,
                `Net Income` = `Total Revenue, Net of Interest Income` - `Total Noninterest Expense`) %>% 
  dplyr::mutate_if(.predicate = is.numeric, scales::dollar) %>% 
  dplyr::select('Loans & Leases','Debt Securities', 'Other Interest Income', 'Total Interest Income',
                'Deposits', 'Long-term Debt', 'Total Interest Expense', 'Net Interest Income',
                'Card Income', 'Service Charges', 'Total Noninterest Income',
                'Total Revenue, Net of Interest Income',
                'Personnel', 'Occupancy', 'Marketing', 'Total Noninterest Expense',
                'Net Income') %>% 
  data.table::transpose(keep.names = "Fields") %>% 
  dplyr::ungroup() %>% 
  janitor::row_to_names(1) %>% 
  dplyr::select(1:6)

rownames(final1) <- NULL

cols <- colnames(final1)
colnames(final1) <- c("", cols[2:6])
