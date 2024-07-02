library(dplyr)

# Función de densidad fθ(x)
f_theta <- function(x, theta) {
  ifelse(x > theta, 2 * exp(-2 * (x - theta)), 0)
}

# Función para generar una muestra aleatoria
generate_sample <- function(n, theta) {
  sample <- rexp(n, rate = 2) + theta
  return(sample)
}

# Función para calcular el intervalo de confianza utilizando el pivote T1
interval_T1 <- function(sample, alpha) {
  n <- length(sample)
  x_mean <- mean(sample)
  z_lower <- qnorm(1-alpha/2)
  z_upper <- qnorm(alpha/2)
  
  lower <- x_mean - 1/2 - (2*z_lower/sqrt(n))
  upper <- x_mean - 1/2 - (2*z_upper/sqrt(n))
  
  return(c(lower, upper))
}

# Función para calcular el intervalo de confianza utilizando el pivote T2
interval_T2 <- function(sample, alpha, theta) {
  n <- length(sample)
  min_x <- min(sample)
  q_lower <- qexp(1-alpha/2, rate=2*n)
  q_upper <- qexp(alpha/2, rate=2*n)
  
  lower <- min_x-q_lower
  upper <- min_x-q_upper
  
  return(c(lower, upper))
}

# Función para calcular el intervalo de confianza utilizando el pivote T3
interval_T3 <- function(sample, alpha, theta) {
  n <- length(sample)
  sum_x <- sum(sample)
  q_lower <- qgamma(1-alpha/2, shape=n, scale=1/2)
  q_upper <- qgamma(alpha/2, shape=n, scale=1/2)
  
  lower <- (sum_x-q_lower)/n
  upper <- (sum_x-q_upper)/n
  
  return(c(lower, upper))
}


# Configuración de la simulación
set.seed(123)  # Para reproducibilidad

alpha <- 0.05
k <- 5000

# Inicialización de contadores y almacenamiento de resultados
results <- data.frame()

# Experimento
for (n_value in c(10, 30, 100, 1000)) {
  for (theta_value in c(2, 5)) {
    coverage_T1 <- coverage_T2 <- coverage_T3 <-numeric(k)
    lengths_T1 <- lengths_T2 <- lengths_T3  <- numeric(k)
    
    for (i in 1:k) {
      sample <- generate_sample(theta = theta_value, n = n_value)
      
      interval_T1_values <- interval_T1(sample, alpha)
      lengths_T1[i] <- diff(interval_T1_values)
      coverage_T1[i] <- as.numeric(theta_value >= interval_T1_values[1] && theta_value <= interval_T1_values[2])
      
      interval_T2_values <- interval_T2(sample, alpha,theta_value)
      lengths_T2[i] <- diff(interval_T2_values)
      coverage_T2[i] <- as.numeric(theta_value >= interval_T2_values[1] && theta_value <= interval_T2_values[2])
    
      interval_T3_values <- interval_T3(sample, alpha,theta_value)
      lengths_T3[i] <- diff(interval_T3_values)
      coverage_T3[i] <- as.numeric(theta_value >= interval_T3_values[1] && theta_value <= interval_T3_values[2])
      }
    
    results <- rbind(results, data.frame(
      n = n_value,
      theta = theta_value,
      method = "p1",
      length = mean(lengths_T1),
      coverage = mean(coverage_T1)
    ))
    
    results <- rbind(results, data.frame(
      n = n_value,
      theta = theta_value,
      method = "p2",
      length = mean(lengths_T2),
      coverage = mean(coverage_T2)
    ))
    
    results <- rbind(results, data.frame(
      n = n_value,
      theta = theta_value,
      method = "p3",
      length = mean(lengths_T3),
      coverage = mean(coverage_T3)
    ))
  }
}

### Consigna 2 ###

print(results)

# Convertir 'results' a dataframe
results <- as.data.frame(results)


### Consigna 3 ###

# Calcular la longitud promedio para cada método y combinación de parámetros
mean_lengths <- aggregate(length ~ n + theta + method, data = results, FUN = mean)

mean_lengths$length <- round(mean_lengths$length, digits = 4)

print(mean_lengths)

mean_lengths_method <- aggregate(length ~ method, data = mean_lengths, FUN = mean)

mean_lengths_method$length <- round(mean_lengths_method$length, digits = 4)

print(mean_lengths_method)

### Consigna 4 #### 

# Calcular la cobertura para cada método y combinación de parámetros
coverage <- aggregate(coverage ~ n + theta + method, data = results, FUN = mean)

coverage$coverage <- round(coverage$coverage, digits = 2)

print(coverage)

mean_coverage_method <- aggregate(coverage ~ method, data = coverage, FUN = mean)

mean_coverage_method$coverage <- round(mean_coverage_method$coverage, digits = 2)

print(mean_coverage_method)
