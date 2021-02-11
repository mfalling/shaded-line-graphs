# Library -----------------------------------------------------------------
library(ggplot2)

# Create Data -------------------------------------------------------------

times <- sample(x = seq(from = as.POSIXct("2021/02/10"), 
                        to = as.POSIXct("2021/02/11"), 
                        by = "15 sec"),
                size = 1000)
times <- sort(times)

values <- c(rnorm(500, mean = -0.25, sd = .25),
            rnorm(250, mean = .25, sd = .40),
            rnorm(250, mean = .50, sd = .50))

df <- data.frame(times, values)
write.csv(df, "output/df.csv")

# Example Plots -----------------------------------------------------------

# Line Graph 
ggplot(df, aes(x = times, y = values)) + 
  geom_line() +
  geom_hline(yintercept = 0) +
  labs(title = "Line Graph") +
  theme_minimal()
ggsave("output/1_Line.png")

# Colored Line Graph 
ggplot(df, aes(x = times, y = values)) + 
  geom_line() +
  geom_area(fill = "blue") +
  geom_hline(yintercept = 0) +
  labs(title = "With Color") +
  theme_minimal()
ggsave("output/2_Color.png")

# Dual-Colored Line Graph
ggplot(df, aes(x = times, y = values)) + 
  geom_line() +
  geom_area(data = df[df$values >= 0, ], 
            fill = "green2") +
  geom_area(data = df[df$values <= 0, ], 
            fill = "red2") +
  geom_hline(yintercept = 0) +
  labs(title = "With Two Colors") +
  theme_minimal()
ggsave("output/3_Colors.png")

# Insert Boundary Points --------------------------------------------------

# Compare two neighboring rows.
# If the sign flips from negative to positive, add a `value` = 0 "boundary".
boundaries <- NULL
for (i in 1:nrow(df)){
  neighbors <- df[i:(i + 1), 2]
  neighbors
  signs <- sign(neighbors)
  signChange <- sum(signs) == 0
  if (is.na(signChange)){
    break
  } else {
    if (signChange == TRUE){
      times <- mean(df[i:(i + 1), 1])
      values <- 0
      boundaryPoint <- data.frame(times, values)
      boundaries <- rbind(boundaries, boundaryPoint)
    }
  }
}

df <- rbind(df, boundaries)

# Adjusted Plots ----------------------------------------------------------

ggplot(df, aes(x = times, y = values)) + 
  geom_line() +
  geom_area(data = df[df$values >= 0, ], 
            fill = "green2") +
  geom_area(data = df[df$values <= 0, ], 
            fill = "red2") +
  geom_hline(yintercept = 0) +
  labs(title = "With Boundary Points") +
  theme_minimal()
ggsave("output/4_Boundaries.png")

# Color-code the line too:
ggplot(df, aes(x = times, y = values)) + 
  geom_line(data = df[df$values >= 0, ], 
            color = "green2") +
  geom_line(data = df[df$values <= 0, ], 
            color = "red2") +
  geom_area(data = df[df$values >= 0, ], 
            fill = "green2") +
  geom_area(data = df[df$values <= 0, ], 
            fill = "red2") +
  geom_hline(yintercept = 0) +
  labs(title = "Color-Coded Line Graph") +
  theme_minimal()
ggsave("output/5_Boundaries.png")
