### Read in both datasets
data=read.csv('/home/jonas/PycharmProjects/pythonProject/data/athletes.csv') 
anon_data=read.csv('/home/jonas/PycharmProjects/pythonProject/data/anonymized_athletes.csv') 


### Height and weight histogram display (filter out inhumane values for better visualisation)
filtered_data_h <- data[data$height >= 50 & data$height <=100,]
filtered_data_w <- data[data$weight >= 0 & data$weight <=500,]

anon_filtered_data_h <- anon_data[anon_data$height_distorted >= 50 & anon_data$height_distorted <=100,]
anon_filtered_data_w <- anon_data[anon_data$weight_distorted >= 0 & anon_data$weight_distorted <=500,]

hist(filtered_data_h$height, breaks <- 50, main = "Histogram of athletes' height",
     xlab = "Height")

hist(filtered_data_w$weight, breaks <- 50, main = "Histogram of athletes' weight",
     xlab = "Weight")

### Standard deviation and mean calculation
sd(filtered_data_w$weight, na.rm=T)
sd(filtered_data_h$height, na.rm=T)

mean(filtered_data_w$weight, na.rm=T)
mean(filtered_data_h$height, na.rm=T)

sd(anon_filtered_data_w$weight_distorted, na.rm=T)
sd(anon_filtered_data_h$height_distorted, na.rm=T)

mean(anon_filtered_data_w$weight_distorted, na.rm=T)
mean(anon_filtered_data_h$height_distorted, na.rm=T)

### Height and weight histograms for the anonymized dataset
hist(anon_filtered_data_h$height_distorted, breaks = 50, main = "Histogram of anon. athletes' height",
     xlab = "Height")

hist(anon_filtered_data_w$weight_distorted, breaks = 50, main = "Histogram of anon. athletes' weight",
     xlab = "Weight")


### Information Loss calculation as of chart 11, lecture 4
inner_1 <- sum((data$height - anon_data$height_distorted) / sqrt(2 * sd(data$height, na.rm = T)), na.rm = T)
inner_1
inner_2 <- sum((data$weight - anon_data$weight_distorted) / sqrt(2 * sd(data$weight, na.rm = T)), na.rm = T)
inner_2
n <- nrow(data)
info_loss <- (inner_1 + inner_2)/(2*n)
info_loss

### Information Loss for categorical data through distinct value analysis
length(unique(data$name))
length(unique(anon_data$pseudo_name))

length(unique(data$region))
length(unique(anon_data$rand_region))

length(unique(data$affiliate))
length(unique(anon_data$rand_affiliate))

length(unique(data$team))
length(unique(anon_data$rand_team))

length(unique(data$age))
length(unique(anon_data$age_bins))

max(data$age, na.rm = T)    # 125, oldest athlete, used for age bin choice

