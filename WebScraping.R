# Web Scraping Fundamentals with rvest
# -------------------------------------
# This script demonstrates how to use the rvest package to scrape data from websites.
# We'll use "http://quotes.toscrape.com/" as a practice site, which is designed for scraping.

# Load required packages
library(tidyverse)  # For data manipulation and piping (%>%)
library(rvest)      # For web scraping
library(purrr)      # For mapping functions

# -----------------------------------------------------------------------------
# Step 1: Reading a Webpage
# -----------------------------------------------------------------------------
# Define the URL for our example website.
url <- "http://quotes.toscrape.com/"

# Read in the webpage content.
page <- read_html(url)

# -----------------------------------------------------------------------------
# Step 2: Inspecting the HTML and Extracting Text Content
# -----------------------------------------------------------------------------
# Use your browser's Developer Tools to inspect the structure of the webpage.
# Here, we observe that each quote's text is within a <span> element with class "text".

# Extract all quote texts.
quotes <- page %>% 
  html_elements(".text") %>%  # CSS selector for elements with class "text"
  html_text()                 # Extract the text content

# Display the first few quotes.
print("Quotes:")
print(head(quotes))

# -----------------------------------------------------------------------------
# Step 3: Extracting Additional Data (Authors and Tags)
# -----------------------------------------------------------------------------
# Extract the authors (located in <small class="author"> elements).
authors <- page %>% 
  html_elements(".author") %>% 
  html_text()

print("Authors:")
print(head(authors))

# Extract tags for each quote.
# Note: Each quote block is contained in a <div> element with class "quote".
quote_blocks <- page %>% html_elements(".quote")

# For each quote block, extract the text, the author, and the associated tags.
quotes_data <- map_df(quote_blocks, function(block) {
  text <- block %>% html_element(".text") %>% html_text()
  author <- block %>% html_element(".author") %>% html_text()
  # Tags are within elements with class "tag"
  tag_nodes <- block %>% html_elements(".tag")
  tags <- tag_nodes %>% html_text() %>% paste(collapse = ", ")
  tibble(quote = text, author = author, tags = tags)
})

print("Quotes Data:")
print(quotes_data)

# -----------------------------------------------------------------------------
# Step 4: Extracting Attributes
# -----------------------------------------------------------------------------
# Extract an attribute from an element.
# For instance, each quote block contains a link (<a>) that points to the author's bio.
bio_links <- quote_blocks %>% 
  html_element("a") %>%  # Select the first <a> element in each block.
  html_attr("href")      # Extract the href attribute (the URL)

# Since the links are relative, we combine them with the base URL.
bio_links_full <- paste0(url, bio_links)
print("Bio Links:")
print(head(bio_links_full))

# -----------------------------------------------------------------------------
# Step 5: Scraping Tables from a Webpage
# -----------------------------------------------------------------------------
# Many websites have tables you can directly convert to data frames.
# For demonstration, we'll scrape a table from Wikipedia.
# Let's use a Wikipedia page for "List of countries by GDP (nominal)".
gdp_url <- "https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)"
gdp_page <- read_html(gdp_url)

# Extract all table nodes from the page.
tables <- gdp_page %>% html_elements("table")

# Convert the first table into a data frame.
gdp_table <- tables[[2]] %>% html_table(fill = TRUE)
print("GDP Table (first few rows):")
print(head(gdp_table))

# -----------------------------------------------------------------------------
# Step 6: Navigating Through Multiple Pages
# -----------------------------------------------------------------------------
# Many sites paginate their content. We can loop through a few pages.
# For example, scraping the first 2 pages of quotes.

all_quotes <- list()

for (i in 1:2) {
  page_url <- paste0(url, "page/", i, "/")
  cat("Scraping page:", page_url, "\n")
  
  # Read in the page content.
  page <- read_html(page_url)
  quote_blocks <- page %>% html_elements(".quote")
  
  # Extract data for each quote block.
  page_quotes <- map_df(quote_blocks, function(block) {
    text <- block %>% html_element(".text") %>% html_text()
    author <- block %>% html_element(".author") %>% html_text()
    tag_nodes <- block %>% html_elements(".tag")
    tags <- tag_nodes %>% html_text() %>% paste(collapse = ", ")
    tibble(quote = text, author = author, tags = tags)
  })
  
  # Append the data frame to our list.
  all_quotes[[i]] <- page_quotes
  
  # Pause briefly between requests to be respectful to the server.
  Sys.sleep(1)
}

# Combine all pages into one data frame.
all_quotes_df <- bind_rows(all_quotes)
print("Combined Quotes from Page 1 and 2:")
print(head(all_quotes_df))

# -----------------------------------------------------------------------------
# Step 7: Error Handling in Web Scraping
# -----------------------------------------------------------------------------
# It is good practice to handle errors gracefully.
# Here, we attempt to scrape a non-existent page.

nonexistent_url <- paste0(url, "page/999/")
page_data <- tryCatch({
  read_html(nonexistent_url)
}, error = function(e) {
  cat("Error encountered:", e$message, "\n")
  NULL
})

if (is.null(page_data)) {
  cat("Failed to scrape page:", nonexistent_url, "\n")
}

# -----------------------------------------------------------------------------
# End of Web Scraping Tutorial
# -----------------------------------------------------------------------------
cat("Web scraping tutorial completed.\n")

