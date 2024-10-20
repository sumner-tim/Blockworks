
# Load necessary libraries
library(igraph)
library(tidyverse)
library(rlang)

########################
# Churn Rate Functions #
########################

# Function to estimate user churn rate
estimate_user_churn <- function(data, from_col, to_col, time_col, inactivity_days = 90) {
  # Convert the time column to datetime if not already
  data[[time_col]] <- as_datetime(data[[time_col]])
  
  # Get the list of all unique users (both from and to addresses)
  users <- unique(c(data[[from_col]], data[[to_col]]))
  
  # Get the most recent transaction time for each user
  last_txn_times <- data %>%
    select(user = all_of(from_col), time = all_of(time_col)) %>%
    bind_rows(data %>%
                select(user = all_of(to_col), time = all_of(time_col))) %>%
    group_by(user) %>%
    summarise(last_txn_time = max(time, na.rm = TRUE), .groups = 'drop')
  
  # Find the latest transaction time in the entire dataset
  latest_txn_time <- max(data[[time_col]], na.rm = TRUE)
  
  # Calculate the inactivity threshold (e.g., 30 days before the last transaction)
  inactivity_threshold <- latest_txn_time - days(inactivity_days)
  
  # Count the number of churned users (users who have not interacted in the last 'inactivity_days' days)
  churned_users <- sum(last_txn_times$last_txn_time < inactivity_threshold)
  
  # Calculate the churn rate as the percentage of churned users over total users
  churn_rate <- (churned_users / length(users))
  
  return(churn_rate)
}

# Function to estimate volume churn rate
estimate_volume_churn <- function(data, from_col, to_col, time_col, volume_col) {
  # Convert the time column to datetime if not already
  data[[time_col]] <- as_datetime(data[[time_col]])
  
  # Combine both from and to columns to get all users
  data <- data %>%
    mutate(user = paste(!!sym(from_col), !!sym(to_col), sep = "_"))
  
  # Order data by time to calculate initial and final transaction volumes
  data <- data %>% arrange(!!sym(time_col))
  
  # Calculate the initial transaction volume for each user (first period)
  initial_volume <- data %>%
    group_by(user) %>%
    filter(row_number() == 1) %>%
    summarise(initial_volume = sum(!!sym(volume_col)), .groups = 'drop')
  
  # Calculate the final transaction volume for each user (last period)
  final_volume <- data %>%
    group_by(user) %>%
    filter(row_number() == n()) %>%
    summarise(final_volume = sum(!!sym(volume_col)), .groups = 'drop')
  
  # Join the initial and final volumes for comparison
  volume_comparison <- initial_volume %>%
    inner_join(final_volume, by = "user")
  
  # Identify users whose transaction volume has decreased or dropped to zero
  churned_users <- volume_comparison %>%
    filter(final_volume < initial_volume)
  
  # Calculate the churn rate as a percentage
  churn_rate <- (nrow(churned_users) / nrow(volume_comparison))
  
  return(churn_rate)
}

############
# Get Data #
############

csv_files <- c(
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Ankr%20Staked%20ETH%20(ankrETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Coinbase%20Wrapped%20Staked%20ETH%20(cbETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Crypto.com%20Staked%20ETH%20(CDCETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Eigenpie%20mstETH%20(MSTETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Frax%20Staked%20Ether%20(SFRXETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Kelp%20DAO%20Restaked%20ETH%20(RSETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Lido%20Staked%20ETH%20(stETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Liquid%20Staked%20ETH%20(LSETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Mantle%20Staked%20Ether%20(METH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/PUFETH%20(pufETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Renzo%20Restaked%20ETH%20(EZETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Restaked%20Swell%20Ethereum%20(RSWETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Rocket%20Pool%20ETH%20(RETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/SWETH%20(swETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Stader%20ETHx%20(ETHX).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/StakeWise%20Staked%20ETH%20(osETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Wrapped%20Beacon%20ETH%20(WBETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Wrapped%20Origin%20Ether%20(WOETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/Wrapped%20eETH%20(weETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/ether.fi%20Staked%20ETH%20(EETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/pzETH%20(PZETH).csv",
  "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Data/sETH2%20(SETH2).csv"
)

# Define a function to process each CSV file
process_file <- function(file_url) {
  # Read the CSV file from the public folder
  token.txn <- read.csv(file_url)
  
  ## Churn Rates ##
  User_Churn <- estimate_user_churn(token.txn, "from", "to", "evt_block_time")
  Volume_Churn <- estimate_volume_churn(token.txn, "from", "to", "evt_block_time", "value")
  
  # Create an edge list for the graph (using 'from' and 'to' as nodes)
  g <- graph_from_data_frame(token.txn[, c("from", "to")], directed = TRUE)
  Degree <- centr_degree(g)$centralization
  Betweenness <- centr_betw(g, directed = TRUE)$centralization
  
  # Extract the token name from the URL (assuming it’s at the end of the URL)
  token_name <- str_remove(basename(file_url), ".csv")
  token_name <- str_replace_all(token_name, "%20", " ")
  
  # Return the processed results as a tibble
  return(tibble(
    Token = token_name, 
    `User Churn` = User_Churn,
    `Volume Churn` = Volume_Churn,
    Degree,
    Betweenness
  ))
}

# Apply the function to all CSV files and bind the results into a single tibble
token.results <- lapply(csv_files, process_file) %>% 
  bind_rows()

# Import design matrix and append responses
design_url <- "https://raw.githubusercontent.com/sumner-tim/Blockworks/refs/heads/main/Design/design_matrix.csv"
design_df <- design_url %>%
  read.csv() %>%
  inner_join(token.results, by = "Token") %>%
  as.data.frame()

###########
# Visuals #
###########

# Function to generate a single interaction plot
interaction_plot <- function(data, interaction_terms, response_var, pct = F) {
  
  # Ensure that the vector has exactly two interaction terms
  if (length(interaction_terms) != 2) {
    stop("Please provide exactly two interaction terms.")
  }
  
  # Dynamically group by the interaction terms, calculate summary statistics
  plot_data <- data %>%
    group_by(!!sym(interaction_terms[1]), !!sym(interaction_terms[2])) %>%
    summarise(
      std.err = sd(!!sym(response_var)) / sqrt(n()),
      response_mean = mean(!!sym(response_var)),
      .groups = 'drop'
    )
  
  # Generate the interaction plot
  p <- ggplot(plot_data, aes(x = !!sym(interaction_terms[1]), y = response_mean, 
                             color = factor(!!sym(interaction_terms[2])),
                             ymin = response_mean - std.err * 0.5, 
                             ymax = response_mean + std.err * 0.5)) +
    geom_pointrange(size = 1) +
    geom_line() +
    scale_x_continuous(breaks = c(-1, 1)) +
    theme_classic() +
    theme(panel.grid.major.y = element_line(linetype = "dashed"),
          panel.grid.minor.y = element_line(linetype = "dashed"),
          legend.position = "bottom") +
    scale_color_manual(values = c("#DA4453", "#8CC152")) +
    labs(color = interaction_terms[2], y = response_var, x = interaction_terms[1])
  
  # Add Percents on y-axis if necessary
  if(pct){
    p <- p +
      scale_y_continuous(labels = scales::percent_format())
  }
  
  # Print the plot
  print(p)
}
# Function to generate a single scatter plot
create_scatter_plot <- function(data, x_var, y_var, pct = F) {
  
  # Extract Ticker from the Token column and create the scatter plot
  p <- data %>%
    mutate(Ticker = str_extract(Token, "\\(([^)]+)\\)")) %>%
    ggplot(mapping = aes(x = !!sym(x_var), y = !!sym(y_var), label = Ticker)) +
    geom_point(col = "#37BC9B") +
    geom_text(check_overlap = TRUE, vjust = "inward", hjust = "inward", size = 3, col = "#434A54") +
    theme_bw() +
    labs(title = paste(y_var, "vs", x_var), x = x_var, y = y_var)
  
  # Add Percents on x and y-axis if necessary
  if(pct){
    p <- p +
      scale_y_continuous(labels = scales::percent_format()) +
      scale_x_continuous(labels = scales::percent_format())
  }
  
  # Return the plot
  return(p)
}
# Function to generate a single box plot
create_boxplot <- function(data, x_var, pct = F) {
  
  # Reshape the data using pivot_longer
  long_data <- data %>%
    pivot_longer(cols = -all_of(c("Token", "User Churn", "Volume Churn", "Degree", "Betweenness")),
                 names_to = "Factors", values_to = "Level")
  
  # Create the boxplot
  p <- ggplot(long_data, aes(y = Factors, x = !!sym(x_var), fill = factor(Level))) +
    geom_boxplot(alpha = 0.7) +
    scale_fill_manual(values = c("#0C1845", "#8109B7")) +
    theme_minimal() +
    labs(fill = "Level", y = "")
  
  # Add Percents on x-axis if necessary
  if(pct){
    p <- p +
      scale_x_continuous(labels = scales::percent_format())
  }
  
  # Return the plot
  return(p)
}

##########################
# Traditional Benchmarks #
##########################

create_scatter_plot(design_df, "User Churn", "Volume Churn", pct = T)

## User Churn ##
create_boxplot(design_df, "User Churn", pct = T)
interaction_plot(design_df, c("Lockup Period", "APY"), "User Churn", pct = T)
interaction_plot(design_df, c("Lockup Period", "Slashing Risk"), "User Churn", pct = T)
interaction_plot(design_df, c("Lockup Period", "Governance Participation"), "User Churn", pct = T)

## Volume Churn Rate ##
create_boxplot(design_df, "Volume Churn", pct = T)
interaction_plot(design_df, c("Liquidity", "Governance Participation"), "Volume Churn", pct = T)
interaction_plot(design_df, c("Ecosystem Support", "APY"), "Volume Churn", pct = T)

## Model ##
lm(cbind(`User Churn`, `Volume Churn`) ~ `Ecosystem Support`:`APY` +
     `Lockup Period`:`APY` +
     `Lockup Period`:`APY`:`Ecosystem Support`, data=design_df)


######################
# Network Benchmarks #
######################

create_scatter_plot(design_df, "Degree", "Betweenness", pct = T)

## Degree Centrality ##
create_boxplot(design_df, "Degree")
interaction_plot(design_df, c("Lockup Period", "Liquidity"), "Degree")
interaction_plot(design_df, c("Lockup Period", "Security & Audits"), "Degree")

## Betweenness Centrality ##
create_boxplot(design_df, "Betweenness")
interaction_plot(design_df, c("Lockup Period", "Liquidity"), "Betweenness")
interaction_plot(design_df, c("Governance Participation", "Liquidity"), "Betweenness")
interaction_plot(design_df, c("Lockup Period", "Ecosystem Support"), "Betweenness")

## Model ##
lm(cbind(Degree, Betweenness) ~ `Lockup Period`:`Liquidity` +
     `Lockup Period`:`Ecosystem Support` +
     `Lockup Period`:`Security & Audits`, data = design_df)



  