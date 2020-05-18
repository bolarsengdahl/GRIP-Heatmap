##########################################################
# Example plotting heat-maps using "Grip_Heatmap_functions_2.1"
# 15.5.2020 - Bo Engdahl
#
##########################################################

working_dir<- "H:/00 Prosjekter/Smerte/Kroppskartet/"
setwd(working_dir)

##########################################################
# Run Grip_Heatmap_funcions_2.1 
#########################################################

source("functions/Grip_Heatmap_functions_2.1.R")

##########################################################
# Set some directories 
#########################################################
svg_dir<- paste(working_dir, "svg/", sep='')
grip_dir <- paste(working_dir, "data/", sep='')
image_dir <- paste(working_dir, "image/", sep='')


# Set number of colors
number_colors=100

# Set colors for prevalence data (different shades of blue) 
colors <- c("#eff3ff", "#4292c6", "black")

# Set rang of prevalence numbers
range <- c(0,0.4)


# Plot first tier 
plotHeat("first_tier_man.svg", "first_tier_man.csv", "first_man", color_start_stop=colors, range=range, leg=TRUE)
plotHeat("first_tier_woman.svg", "first_tier_woman.csv", "first_woman", color_start_stop=colors, range=range)


# Set rang of prevalence numbers in %
range <- c(0,20)
# Plot second tier
plotHeat("second_tier_man.svg", "second_tier_man.csv", "second_man", color_start_stop=colors, range=range, leg=TRUE)
plotHeat("second_tier_woman.svg", "second_tier_woman.csv", "second_woman", color_start_stop=colors, range=range)


# Set colors for VAS data (from yellow to black)
colors <- c("yellow", "red", "black")

# Set range of VAS data
range <- c(3.5,5.5)

# Plot first tier VAS
plotHeat("first_tier_man.svg", "first_tier_man_VAS.csv", "man_VAS", color_start_stop=colors, range=range, leg=TRUE)
plotHeat("first_tier_woman.svg", "first_tier_woman_VAS.csv", "woman_VAS", colors, number_colors, range)
