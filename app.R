#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Load necessary libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(ggmap)
library(DT)

# Register Google Maps API key for ggmap usage if you have one
# register_google(key = "YOUR_GOOGLE_API_KEY")

# Define UI for the dashboard
ui <- dashboardPage(
  dashboardHeader(
    title = "Healthcare Insights Dashboard",
    dropdownMenu(
      type = "notifications",
      icon = icon("bell"),
      badgeStatus = "danger",
      notificationItem(
        text = "New patient data added",
        icon = icon("heartbeat"),
        status = "info"
      ),
      notificationItem(
        text = "Pending tasks in the system",
        icon = icon("exclamation-triangle"),
        status = "warning"
      )
    )
  ),
  
  # Sidebar layout with input and output definitions
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("info-circle")),
      menuItem("Patient Overview", tabName = "overview", icon = icon("user-md")),
      menuItem("Data Analysis", tabName = "analysis", icon = icon("chart-bar")),
      menuItem("Patient Risk Assessment", tabName = "risk", icon = icon("exclamation-triangle")),
      menuItem("Patient Appointment Form", tabName = "appointment", icon = icon("calendar-plus")),
      menuItem("Settings", tabName = "settings", icon = icon("cogs"))
    )
  ),
  
  # Define main content for each tab
  dashboardBody(
    tabItems(
      # Introduction tab with detailed description
      tabItem(
        tabName = "intro",
        h2("Welcome to the Healthcare Insights Dashboard"),
        p("This dashboard is designed to provide healthcare professionals with real-time insights and trends 
          related to patient demographics, health indicators, and hospital admission patterns. The aim is 
          to support data-driven decision-making in clinical settings.")
      ),
      
      # Patient Overview tab with demographic plots and map
      tabItem(
        tabName = "overview",
        fluidRow(
          valueBox("1,200", "Total Patients", icon = icon("users"), color = "blue"),
          valueBox("350", "New Admissions", icon = icon("hospital"), color = "green"),
          valueBox("45", "Critical Patients", icon = icon("exclamation-triangle"), color = "red")
        ),
        fluidRow(
          box(
            title = "Patient Demographics",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotOutput("ageDistPlot")
          ),
          box(
            title = "Patient Distribution Map",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotOutput("patientDistMap")
          )
        )
      )
    )
  )
)

# Define server logic required for the dashboard
server <- function(input, output) {
  
  # Sample data for age distribution
  age_data <- data.frame(age = rnorm(100, mean = 45, sd = 15))
  
  # Render age distribution plot using ggplot2
  output$ageDistPlot <- renderPlot({
    ggplot(age_data, aes(x = age)) +
      geom_histogram(binwidth = 5, fill = "skyblue", color = "white") +
      labs(title = "Age Distribution of Patients", x = "Age", y = "Frequency") +
      theme_minimal()
  })
  
  # Sample data for patient distribution with lat/lon coordinates
  patient_data <- data.frame(
    lat = c(34.0522, 40.7128, 37.7749, 41.8781, 29.7604), # Sample latitudes
    lon = c(-118.2437, -74.0060, -122.4194, -87.6298, -95.3698), # Sample longitudes
    city = c("Los Angeles", "New York", "San Francisco", "Chicago", "Houston")
  )
  
  # Render patient distribution map using ggmap
  output$patientDistMap <- renderPlot({
    # Get a base map (e.g., USA centered) - specify your region or use map bounds dynamically
    usa_map <- get_map(location = "USA", zoom = 4, maptype = "terrain")
    
    # Plot patients on the map
    ggmap(usa_map) +
      geom_point(data = patient_data, aes(x = lon, y = lat), color = "red", size = 3, alpha = 0.7) +
      labs(title = "Patient Distribution by Location") +
      theme_minimal()
  })
}

# Run the application 
shinyApp(ui, server)
