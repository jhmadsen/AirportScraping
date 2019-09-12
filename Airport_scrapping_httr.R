library(httr)
library(XML)


content_page <- httr::GET("https://www.cph.dk/en/flight-information/departures")
content_text <- XML::htmlParse(content_page, asText=TRUE)
flight_containers <- XML::xpathApply(content_text, "//div[@class='stylish-table__row stylish-table__row--body']")

flight_date <- NULL
departure_time <- NULL
airline <- NULL
destination <- NULL
flight_number <- NULL

flight_df <- data.frame(flight_date=character(), 
                        departure_time=character(), 
                        airline=character(), 
                        destination=character(), 
                        flight_number=character(),
                        stringsAsFactors = FALSE)

for(i in 1:length(flight_containers)){
  
  row_container <- flight_containers[[i]]
  row_container_cols <- XML::xpathApply(row_container, 'div/div/span')
  row_container_cols_val <- XML::xmlValue(row_container_cols)
  
  flight_date <- as.character(as.Date(Sys.Date(), format="%m/%d/%Y"))
  
  if(length(row_container_cols)==9){
    
    departure_time <- row_container_cols_val[1]
    airline <- row_container_cols_val[2]
    destination <- row_container_cols_val[3]
    flight_number <- row_container_cols_val[5]
    
  } else {
    
    departure_time <- row_container_cols_val[1]
    airline <- row_container_cols_val[4]
    destination <- row_container_cols_val[5]
    flight_number <- row_container_cols_val[7]
    
  }
  
  flight_vector <- c(flight_date, departure_time, airline, destination, flight_number)
  print(flight_vector)
  
  flight_df[i,] <- flight_vector
}

write.csv(flight_df, paste("C:\\Users\\jacma\\Desktop\\", "flights - ", Sys.Date(), ".csv", sep=''), row.names=FALSE)
