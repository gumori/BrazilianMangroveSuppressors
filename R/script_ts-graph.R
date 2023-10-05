# Description of this script

# This script aims:

# Create time series and trends of suppressed, replaced by LULC and expanded of Brazilian mangroves 
# Provides graphics of direct conversion percentage of each LULC  
# Map of the Brazilian coast with states and latitudinal limits (region I to VII)

# Developed by Gabriel Tofanelo Vanin
# authors: Gabriel Tofanelo Vanin, Eduardo Ribeiro Lacerda and Gustavo Maruyama Mori



# used packages:

# graph
if(!require(ggplot2)) install.packages("ggplot2")
library(ggplot2)

# data
if(!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)
if(!require(dplyr)) install.packages("dplyr")
library(dplyr)

# time serie
if(!require(tsibble)) install.packages("tsibble")
library(tsibble) 
if(!require(feasts)) install.packages("feasts")
library(feasts)

# map
if(!require(rgdal)) install.packages("rgdal")
library(rgdal) 
if(!require(sp)) install.packages("sp")
library(sp) 
if(!require(rgeos)) install.packages("rgeos")
library(rgeos) 


# setting working directory:

setwd("C:/Users/Lab/Documents/Gabriel/analises-artigo")


# importing tables:

# land use and land covers categories for regional-scale
FRST_region <- read.table("forest_region.tsv", sep = "\t", header = T)          # forest formation
GRLD_region <- read.table("grassland_region.tsv", sep = "\t", header = T)       # grassland
SVNN_region <- read.table("savanna_region.tsv", sep = "\t", header = T)         # savanna formation
HRSB_region <- read.table("herbSandbank_region.tsv", sep = "\t", header = T)    # herbaceous sandbank vegetation 
WDSB_region <- read.table("woodSandbank_region.tsv", sep = "\t", header = T)    # wooded sandbank vegetation
NFRS_region <- read.table("nonForest_region.tsv", sep = "\t", header = T)       # other non forest formations
NVGT_region <- read.table("nonVegetation_region.tsv", sep = "\t", header = T)   # other non vegetated areas
BDSS_region <- read.table("bdss_region.tsv", sep = "\t", header = T)            # beach, dune and sand spot
STFL_region <- read.table("saltFlat_region.tsv", sep = "\t", header = T)        # salt flat
WTLD_region <- read.table("wetland_region.tsv", sep = "\t", header = T)         # wetland
RLOS_region <- read.table("rlo_region.tsv", sep = "\t", header = T)             # river, lake and ocean
URBN_region <- read.table("urban_region.tsv", sep = "\t", header = T)           # urban area
SGCN_region <- read.table("sugarCane_region.tsv", sep = "\t", header = T)       # sugar cane
RICE_region <- read.table("rice_region.tsv", sep = "\t", header = T)            # rice
PRCP_region <- read.table("pereCrop_region.tsv", sep = "\t", header = T)        # perennial crop
OPCP_region <- read.table("otherPereCrop_region.tsv", sep = "\t", header = T)   # other perennial crops
TPCP_region <- read.table("tempCrop_region.tsv", sep = "\t", header = T)        # temporary crop
OTCP_region <- read.table("otherTempCrop_region.tsv", sep = "\t", header = T)   # other temporary crops
PSTR_region <- read.table("pasture_region.tsv", sep = "\t", header = T)         # pasture
AQUA_region <- read.table("aquaculture_region.tsv", sep = "\t", header = T)     # aquaculture
LOSS_region <- read.table("loss_region.tsv", sep = "\t", header = T)            # mangrove (loss)
GAIN_region <- read.table("gain_region.tsv", sep = "\t", header = T)            # mangrove (gain)

# land use and land covers categories for state-scale
FRST_state <- read.table("forest_state.tsv", sep = "\t", header = T)            # forest formation
GRLD_state <- read.table("grassland_state.tsv", sep = "\t", header = T)         # grassland
SVNN_state <- read.table("savanna_state.tsv", sep = "\t", header = T)           # savanna formation
HRSB_state <- read.table("herbSandbank_state.tsv", sep = "\t", header = T)      # herbaceous sandbank vegetation
WDSB_state <- read.table("woodSandbank_state.tsv", sep = "\t", header = T)      # wooded sandbank vegetation
NFRS_state <- read.table("nonForest_state.tsv", sep = "\t", header = T)         # other non forest formations
NVGT_state <- read.table("nonVegetation_state.tsv", sep = "\t", header = T)     # other non vegetated areas
BDSS_state <- read.table("bdss_state.tsv", sep = "\t", header = T)              # beach, dune and sand spot
STFL_state <- read.table("saltFlat_state.tsv", sep = "\t", header = T)          # salt flat
WTLD_state <- read.table("wetland_state.tsv", sep = "\t", header = T)           # wetland
RLOS_state <- read.table("rlo_state.tsv", sep = "\t", header = T)               # river, lake and ocean
URBN_state <- read.table("urban_state.tsv", sep = "\t", header = T)             # urban area
SGCN_state <- read.table("sugarCane_state.tsv", sep = "\t", header = T)         # sugar cane
RICE_state <- read.table("rice_state.tsv", sep = "\t", header = T)              # rice
PRCP_state <- read.table("pereCrop_state.tsv", sep = "\t", header = T)          # perennial crop
OPCP_state <- read.table("otherPereCrop_state.tsv", sep = "\t", header = T)     # other perennial crops
TPCP_state <- read.table("tempCrop_state.tsv", sep = "\t", header = T)          # temporary crop
OTCP_state <- read.table("otherTempCrop_state.tsv", sep = "\t", header = T)     # other temporary crops
PSTR_state <- read.table("pasture_state.tsv", sep = "\t", header = T)           # pasture
AQUA_state <- read.table("aquaculture_state.tsv", sep = "\t", header = T)       # aquaculture
LOSS_state <- read.table("loss_state.tsv", sep = "\t", header = T)              # mangrove (loss)
GAIN_state <- read.table("gain_state.tsv", sep = "\t", header = T)              # mangrove (gain)



# Time series and decomposing
# ---------------------------


# FIGURE 2 (national):

# for suppression and annual gain values at the national level, we use the values referring to the states:

loss_by_year_national = LOSS_state %>% group_by(year) %>% summarise(total_area_loss = sum(loss))
gain_by_year_national = GAIN_state %>% group_by(year) %>% summarise(total_area_gain = sum(gain))

# calculating the net loss or gain of mangrove: 

delta_national = data.frame(gain_by_year_national$total_area_gain - loss_by_year_national$total_area_loss)
delta_national <- rename(delta_national, net_area = gain_by_year_national.total_area_gain...loss_by_year_national.total_area_loss )
delta_national$year <- seq(2000, 2020) 
delta_national$year <- as.factor(delta_national$year) 

# negative values:

loss_by_year_national$total_area_loss <- loss_by_year_national$total_area_loss * -1

# grouping the loss, gain and delta into a single dataframe:

loss_gain_national = merge(loss_by_year_national, gain_by_year_national, by = "year", suffixes = c("", ""))
variation_areaMgv_national = merge(loss_gain_national, delta_national, by = "year")

# creating common key across all columns:

keyTsibble_national <- rep("brazil", 21)
variation_areaMgv_key_national <- cbind(variation_areaMgv_national, keyTsibble_national)

# new object organized with tsibble for time series:

ts_variation_areaMgv_national = variation_areaMgv_key_national %>% as_tsibble(index = year, key = keyTsibble_national)

# time series with decomposition (trend):

ts_variation_areaMgv_national %>% 
  # first create a column with all the values
  pivot_longer(cols = c(total_area_loss, total_area_gain, net_area), 
               names_to = "Variable", values_to = "Area") %>%
  model(STL(Area)) %>% components() %>% autoplot() +
  ylim(-300, 600)

# curve statistics using feats:

ts_variation_areaMgv_national %>%
  pivot_longer(cols = c(total_area_loss, total_area_gain, net_area), 
               names_to = "Variable", values_to = "Area") %>%
  features(Area, feat_stl)



# FIGURE 2 (regions):

# sum of mangrove areas by year:

loss_by_year = LOSS_region %>% group_by(year) %>% summarise(total_area_loss = sum(loss))
gain_by_year = GAIN_region %>% group_by(year) %>% summarise(total_area_gain = sum(gain))

# calculating the net loss or gain of mangrove: 

delta = data.frame(gain_by_year$total_area_gain - loss_by_year$total_area_loss)
delta <- rename(delta, net_area = gain_by_year.total_area_gain...loss_by_year.total_area_loss )
delta$year <- seq(2000, 2020) 
delta$year <- as.factor(delta$year) 

total_delta = sum(delta$net_area)

# visualization
View(loss_by_year)
View(gain_by_year)
View(delta)

# grouping the loss, gain and delta into a single dataframe:

loss_gain = merge(loss_by_year, gain_by_year, by = "year", suffixes = c("", ""))
variation_areaMgv = merge(loss_gain, delta, by = "year")

# time series referring to area gain, loss and delta:

ggplot(variation_areaMgv) +
  geom_line(aes(x = year, y = total_area_loss), colour = 'red', size = 1) +
  geom_point(aes(x = year, y = total_area_loss), colour = 'red', size = 2) +
  geom_line(aes(x = year, y = total_area_gain), colour = 'green', size = 1) +
  geom_point(aes(x = year, y = total_area_gain), colour = 'green', size = 2) +
  geom_line(aes(x = year, y = net_area), colour = 'black', size = 1) +
  geom_point(aes(x = year, y = net_area), colour = 'black', size = 2) +
  labs(x = "Year", y = "Area (km?)") 
  # SUBTITLE IS MISSING

# creating common key across all columns for new time series using tsibble and fable packages:

keyTsibble <- rep("brazil", 21)
variation_areaMgv_key <- cbind(variation_areaMgv, keyTsibble)
ts_variation_areaMgv = variation_areaMgv_key %>% as_tsibble(index = year, key = keyTsibble)

# new time series with decomposition (trend):

ts_variation_areaMgv %>% 
  # first create a column with all the values
  pivot_longer(cols = c(total_area_loss, total_area_gain, net_area), 
               names_to = "Variable", values_to = "Area") %>%
  mutate(Area = ifelse(Variable == "total_area_loss", -Area, Area)) %>%
  model(STL(Area)) %>%
  components() %>%
  autoplot() + 
  ylim(-400, 600) +
  expand_limits(y = c(-400, 600)) +
  theme_minimal()

# curve statistics:

ts_variation_areaMgv %>%
  pivot_longer(cols = c(total_area_loss, total_area_gain, net_area), 
               names_to = "Variable", values_to = "Area") %>%
  features(Area, feat_stl)

# grouping the loss and gain by:

# regional-scale
loss_gain_region <- merge(LOSS_region, GAIN_region, by = c("year", "level", "id"), suffixes = c("", ""))
# states-scale
loss_gain_state <- merge(LOSS_state, GAIN_state, by = c("year", "level", "id"), suffixes = c("", ""))

# calculating the delta for each 

# regional-scale
loss_gain_region$delta <- loss_gain_region$gain - loss_gain_region$loss
# states-scale
loss_gain_state$delta <- loss_gain_state$gain - loss_gain_state$loss

# grouping the loss, gain and delta into a single dataframe:

ts_variation_areaMgv_region = loss_gain_region %>% as_tsibble(index = year, key = id)

ts_variation_areaMgv_state = loss_gain_state %>% as_tsibble(index = year, key = id)

# time series with decomposition (trend):

ts_variation_areaMgv_region %>% 
  # first create a column with all the values
  pivot_longer(cols = c(loss, gain, delta), 
               names_to = "Variable", values_to = "Area") %>%
  mutate(Area = ifelse(Variable == "loss", -Area, Area)) %>%
  model(STL(Area)) %>%
  components() %>%
  autoplot() 

# defining groups for regions with similar behaviors:

group1 <- ts_variation_areaMgv_region %>%
  filter(id %in% c(1, 2))

group2 <- ts_variation_areaMgv_region %>%
  filter(id %in% c(3, 4))

group3 <- ts_variation_areaMgv_region %>%
  filter(id %in% c(5, 6, 7))

# gain, loss, and delta graph for each group:

plot_group1 <- group1 %>%
  pivot_longer(cols = c(loss, gain, delta), 
               names_to = "Variable", values_to = "Area") %>%
  mutate(Area = ifelse(Variable == "loss", -Area, Area)) %>%
  model(STL(Area)) %>%
  components() %>%
  autoplot() +
  ylim(-100, 200) +
  expand_limits(y = c(-100, 200)) +
  scale_color_manual(values = c("#00008B",  # DarkBlue for delta - region 1 
                                "#CD5C5C",  # IndianRed for delta - region 2
                                "#836FFF",  # SlateBlue 1 for gain - region 1 
                                "#F08080",  # LightCoral for gain - region 2
                                "#836FFF",  # SlateBlue 1 for loss - region 1 
                                "#F08080"   # LightCoral for loss - region 2
                                )) + 
  theme_minimal()

plot_group2 <- group2 %>%
  pivot_longer(cols = c(loss, gain, delta), 
               names_to = "Variable", values_to = "Area") %>%
  mutate(Area = ifelse(Variable == "loss", -Area, Area)) %>%
  model(STL(Area)) %>%
  components() %>%
  autoplot() +
  ylim(-80, 160) +
  expand_limits(y = c(-80, 160)) +
  scale_color_manual(values = c("#FF8C00",  # DarkOrange for delta - region 3 
                                "#9400D3",  # DarkViolet for delta - region 4
                                "#FFA500",  # Orange for gain - region 3 
                                "#BC8F8F",  # RosyBrown for gain - region 4
                                "#FFA500",  # Orange for loss - region 3 
                                "#BC8F8F"   # RosyBrown for loss - region 4
                                )) +  
  theme_minimal()

plot_group3 <- group3 %>%
  pivot_longer(cols = c(loss, gain, delta), 
               names_to = "Variable", values_to = "Area") %>%
  mutate(Area = ifelse(Variable == "loss", -Area, Area)) %>%
  model(STL(Area)) %>%
  components() %>%
  autoplot() +
  ylim(-30, 60) +
  expand_limits(y = c(-30, 60)) +
  scale_color_manual(values = c("#FF0000",  # red for delta - region 5 
                                "#FFD700",  # Gold for delta - region 6
                                "#CD853F",  # Peru for gain - region 7
                                "#FF6347",  # Tomato for gain - region 5
                                "#FFFF00",  # Yellow for loss - region 6 
                                "#D2691E",  # Chocolate for loss - region 7
                                "#FF6347",  # Tomato for gain - region 5
                                "#FFFF00",  # Yellow for loss - region 6 
                                "#D2691E"   # Chocolate for loss - region 7
                                )) +  
  theme_minimal()

# Visualization
plot_group1
plot_group2
plot_group3

# aesthetic option for area gain, loss and delta for each region (without trend):

colors <- c("blue", "pink", "orange", "purple", "red", "yellow", "brown")

ts_variation_areaMgv_region %>%
  pivot_longer(cols = c(loss, gain, delta), names_to = "Variable", values_to = "Area") %>%
  mutate(Area = ifelse(Variable == "loss", -Area, Area),
         id = as.factor(id)) %>%
  ggplot(aes(year, Area, color = id, linetype = Variable)) +
  geom_line(size = 1.2) + 
  scale_color_manual(values = colors) +
  scale_linetype_manual(values = c("dashed", "solid", "solid")) +
  theme_minimal()

# curve statistics:

ts_variation_areaMgv_region %>%
  pivot_longer(cols = c(loss, gain, delta), 
               names_to = "Variable", values_to = "Area") %>%
  features(Area, feat_stl)


# SUPPLEMENTARY FIGURE

# states! (filter)
ts_variation_areaMgv_state %>% 
  # first create a column with all the values
  pivot_longer(cols = c(loss, gain, delta), 
               names_to = "Variable", values_to = "Area") %>%
  mutate(Area = ifelse(Variable == "loss", -Area, Area)) %>%
  filter(id == "MA") %>%
  model(STL(Area)) %>%
  components() %>%
  autoplot() + 
  ylim(-200, 200) +
  expand_limits(y = c(-200, 200)) +
  theme_minimal()


# Calculation of LULC area per year
# ---------------------------------

# sum of land use and land cover areas by:

# year:
FRST_by_year = FRST_region %>% group_by(year) %>% summarise(total_cnvArea = sum(forest))
GRLD_by_year = GRLD_region %>% group_by(year) %>% summarise(total_cnvArea = sum(grassland))
SVNN_by_year = SVNN_region %>% group_by(year) %>% summarise(total_cnvArea = sum(savanna))
HRSB_by_year = HRSB_region %>% group_by(year) %>% summarise(total_cnvArea = sum(herbSandbank))
WDSB_by_year = WDSB_region %>% group_by(year) %>% summarise(total_cnvArea = sum(woodSandbank))
NFRS_by_year = NFRS_region %>% group_by(year) %>% summarise(total_cnvArea = sum(nonForest))
NVGT_by_year = NVGT_region %>% group_by(year) %>% summarise(total_cnvArea = sum(nonVegetation))
BDSS_by_year = BDSS_region %>% group_by(year) %>% summarise(total_cnvArea = sum(bdss))
STFL_by_year = STFL_region %>% group_by(year) %>% summarise(total_cnvArea = sum(saltFlat))
WTLD_by_year = WTLD_region %>% group_by(year) %>% summarise(total_cnvArea = sum(wetland))
RLOS_by_year = RLOS_region %>% group_by(year) %>% summarise(total_cnvArea = sum(rlo))
URBN_by_year = URBN_region %>% group_by(year) %>% summarise(total_cnvArea = sum(urban))
SGCN_by_year = SGCN_region %>% group_by(year) %>% summarise(total_cnvArea = sum(sugarCane))
RICE_by_year = RICE_region %>% group_by(year) %>% summarise(total_cnvArea = sum(rice))
PRCP_by_year = PRCP_region %>% group_by(year) %>% summarise(total_cnvArea = sum(pereCrop))
OPCP_by_year = OPCP_region %>% group_by(year) %>% summarise(total_cnvArea = sum(otherPereCrop))
TPCP_by_year = TPCP_region %>% group_by(year) %>% summarise(total_cnvArea = sum(tempCrop))
OTCP_by_year = OTCP_region %>% group_by(year) %>% summarise(total_cnvArea = sum(otherTempCrop))
PSTR_by_year = PSTR_region %>% group_by(year) %>% summarise(total_cnvArea = sum(pasture))
AQUA_by_year = AQUA_region %>% group_by(year) %>% summarise(total_cnvArea = sum(aquaculture))

# regional-scale
FRST_by_seg = FRST_region %>% group_by(id) %>% summarise(total_cnvArea = sum(forest))
GRLD_by_seg = GRLD_region %>% group_by(id) %>% summarise(total_cnvArea = sum(grassland))
SVNN_by_seg = SVNN_region %>% group_by(id) %>% summarise(total_cnvArea = sum(savanna))
HRSB_by_seg = HRSB_region %>% group_by(id) %>% summarise(total_cnvArea = sum(herbSandbank))
WDSB_by_seg = WDSB_region %>% group_by(id) %>% summarise(total_cnvArea = sum(woodSandbank))
NFRS_by_seg = NFRS_region %>% group_by(id) %>% summarise(total_cnvArea = sum(nonForest))
NVGT_by_seg = NVGT_region %>% group_by(id) %>% summarise(total_cnvArea = sum(nonVegetation))
BDSS_by_seg = BDSS_region %>% group_by(id) %>% summarise(total_cnvArea = sum(bdss))
STFL_by_seg = STFL_region %>% group_by(id) %>% summarise(total_cnvArea = sum(saltFlat))
WTLD_by_seg = WTLD_region %>% group_by(id) %>% summarise(total_cnvArea = sum(wetland))
RLOS_by_seg = RLOS_region %>% group_by(id) %>% summarise(total_cnvArea = sum(rlo))
URBN_by_seg = URBN_region %>% group_by(id) %>% summarise(total_cnvArea = sum(urban))
SGCN_by_seg = SGCN_region %>% group_by(id) %>% summarise(total_cnvArea = sum(sugarCane))
RICE_by_seg = RICE_region %>% group_by(id) %>% summarise(total_cnvArea = sum(rice))
PRCP_by_seg = PRCP_region %>% group_by(id) %>% summarise(total_cnvArea = sum(pereCrop))
OPCP_by_seg = OPCP_region %>% group_by(id) %>% summarise(total_cnvArea = sum(otherPereCrop))
TPCP_by_seg = TPCP_region %>% group_by(id) %>% summarise(total_cnvArea = sum(tempCrop))
OTCP_by_seg = OTCP_region %>% group_by(id) %>% summarise(total_cnvArea = sum(otherTempCrop))
PSTR_by_seg = PSTR_region %>% group_by(id) %>% summarise(total_cnvArea = sum(pasture))
AQUA_by_seg = AQUA_region %>% group_by(id) %>% summarise(total_cnvArea = sum(aquaculture))

# states-scale
FRST_by_state = FRST_state %>% group_by(id) %>% summarise(total_cnvArea = sum(forest))
GRLD_by_state = GRLD_state %>% group_by(id) %>% summarise(total_cnvArea = sum(grassland))
SVNN_by_state = SVNN_state %>% group_by(id) %>% summarise(total_cnvArea = sum(savanna))
HRSB_by_state = HRSB_state %>% group_by(id) %>% summarise(total_cnvArea = sum(herbSandbank))
WDSB_by_state = WDSB_state %>% group_by(id) %>% summarise(total_cnvArea = sum(woodSandbank))
NFRS_by_state = NFRS_state %>% group_by(id) %>% summarise(total_cnvArea = sum(nonForest))
NVGT_by_state = NVGT_state %>% group_by(id) %>% summarise(total_cnvArea = sum(nonVegetation))
BDSS_by_state = BDSS_state %>% group_by(id) %>% summarise(total_cnvArea = sum(bdss))
STFL_by_state = STFL_state %>% group_by(id) %>% summarise(total_cnvArea = sum(saltFlat))
WTLD_by_state = WTLD_state %>% group_by(id) %>% summarise(total_cnvArea = sum(wetland))
RLOS_by_state = RLOS_state %>% group_by(id) %>% summarise(total_cnvArea = sum(rlo))
URBN_by_state = URBN_state %>% group_by(id) %>% summarise(total_cnvArea = sum(urban))
SGCN_by_state = SGCN_state %>% group_by(id) %>% summarise(total_cnvArea = sum(sugarCane))
RICE_by_state = RICE_state %>% group_by(id) %>% summarise(total_cnvArea = sum(rice))
PRCP_by_state = PRCP_state %>% group_by(id) %>% summarise(total_cnvArea = sum(pereCrop))
OPCP_by_state = OPCP_state %>% group_by(id) %>% summarise(total_cnvArea = sum(otherPereCrop))
TPCP_by_state = TPCP_state %>% group_by(id) %>% summarise(total_cnvArea = sum(tempCrop))
OTCP_by_state = OTCP_state %>% group_by(id) %>% summarise(total_cnvArea = sum(otherTempCrop))
PSTR_by_state = PSTR_state %>% group_by(id) %>% summarise(total_cnvArea = sum(pasture))
AQUA_by_state = AQUA_state %>% group_by(id) %>% summarise(total_cnvArea = sum(aquaculture))

# sum of total mangrove area converted by all land use and land cover classes:

# land use
landUse_area <- bind_rows(URBN_by_year, SGCN_by_year, RICE_by_year, PRCP_by_year, OPCP_by_year, TPCP_by_year, OTCP_by_year, PSTR_by_year, AQUA_by_year, NVGT_by_year)

# land cover
landCover_area <- bind_rows(FRST_by_year, GRLD_by_year, SVNN_by_year, HRSB_by_year, WDSB_by_year, NFRS_by_year, BDSS_by_year, STFL_by_year, WTLD_by_year, RLOS_by_year)

# land use and land cover (all)
landUseCover_area <- bind_rows(FRST_by_year, GRLD_by_year, SVNN_by_year, HRSB_by_year, WDSB_by_year, NFRS_by_year, NVGT_by_year, BDSS_by_year, STFL_by_year, WTLD_by_year, RLOS_by_year, URBN_by_year, SGCN_by_year, RICE_by_year, PRCP_by_year, OPCP_by_year, TPCP_by_year, OTCP_by_year, PSTR_by_year, AQUA_by_year)

# sum the area:

totalArea_landUse <- landUse_area %>%
  summarize(totalArea_cnvUse = sum(total_cnvArea))

totalArea_landCover <- landCover_area %>%
  summarize(totalArea_cnvCover = sum(total_cnvArea))

totalArea_landUseCover <- landUseCover_area %>%
  summarize(totalArea_cnvUseCover = sum(total_cnvArea))


# Calulation of total area in different spatial units
# ---------------------------------------------------

# total loss, gain and delta of mangrove area in the:

# Brazil (loss)
totalArea_loss <- LOSS_region %>%
  summarize(total_loss = sum(loss))

# regional (loss)
totalArea_loss_region <- LOSS_region %>%
  group_by(id) %>%  summarize(total_loss_seg = sum(loss))

# states (loss)
totalArea_loss_state <- LOSS_state %>%
  group_by(id) %>%  summarize(total_loss_state = sum(loss))

# Brazil (gain)
totalArea_gain <- GAIN_region %>%
  summarize(total_gain = sum(gain))

# regional (gain)
totalArea_gain_region <- GAIN_region %>%
  group_by(id) %>%  summarize(total_gain_seg = sum(gain))

# states (gain)
totalArea_gain_state <- GAIN_state %>%
  group_by(id) %>%  summarize(total_gain_state = sum(gain))

# Brazil (delta)
totalArea_delta = data.frame(totalArea_gain - totalArea_loss)
totalArea_delta <- rename(totalArea_delta, total_netArea = total_gain)

# regional (delta)
totalArea_delta_region = data.frame(totalArea_gain_region$total_gain_seg - totalArea_loss_region$total_loss_seg)
totalArea_delta_region <- rename(totalArea_delta_region, total_delta_seg = totalArea_gain_region.total_gain_seg...totalArea_loss_region.total_loss_seg)
totalArea_delta_region$id <- seq(1, 7) 
totalArea_delta_region$id <- as.factor(totalArea_delta_region$id)

# states (delta)
totalArea_delta_state = data.frame(totalArea_gain_state$total_gain_state - totalArea_loss_state$total_loss_state)
totalArea_delta_state <- rename(totalArea_delta_state, total_delta_state = totalArea_gain_state.total_gain_state...totalArea_loss_state.total_loss_state)
totalArea_delta_state$id <- c("AL", "AP", "BA", "CE", "ES", "MA", "PA", "PB", "PE", "PI", "PR", "RJ", "RN", "SC", "SE", "SP")
totalArea_delta_state$id <- as.factor(totalArea_delta_state$id) 
totalArea_delta_state <- totalArea_delta_state %>% relocate (id)


# Bar graph (%)
# -------------

# FIGURE 1

# adding "Class" column with the names of each LULC:

# region
FRST_bySeg <- FRST_by_seg %>% mutate(Class = "forest")
GRLD_bySeg <- GRLD_by_seg %>% mutate(Class = "grassland")
SVNN_bySeg <- SVNN_by_seg %>% mutate(Class = "savanna")
HRSB_bySeg <- HRSB_by_seg %>% mutate(Class = "herbSandbank")
WDSB_bySeg <- WDSB_by_seg %>% mutate(Class = "woodSandbank")
NFRS_bySeg <- NFRS_by_seg %>% mutate(Class = "nonForest")
NVGT_bySeg <- NVGT_by_seg %>% mutate(Class = "nonVegetation")
BDSS_bySeg <- BDSS_by_seg %>% mutate(Class = "bdss")
STFL_bySeg <- STFL_by_seg %>% mutate(Class = "saltFlat")
WTLD_bySeg <- WTLD_by_seg %>% mutate(Class = "wetland")
RLOS_bySeg <- RLOS_by_seg %>% mutate(Class = "rlo")
URBN_bySeg <- URBN_by_seg %>% mutate(Class = "urban")
SGCN_bySeg <- SGCN_by_seg %>% mutate(Class = "sugarCane")
RICE_bySeg <- RICE_by_seg %>% mutate(Class = "rice")
PRCP_bySeg <- PRCP_by_seg %>% mutate(Class = "pereCrop")
OPCP_bySeg <- OPCP_by_seg %>% mutate(Class = "otherPereCrop")
TPCP_bySeg <- TPCP_by_seg %>% mutate(Class = "tempCrop")
OTCP_bySeg <- OTCP_by_seg %>% mutate(Class = "otherTempCrop")
PSTR_bySeg <- PSTR_by_seg %>% mutate(Class = "pasture")
AQUA_bySeg <- AQUA_by_seg %>% mutate(Class = "aquaculture")

areaLULC_region_missing = rbind(OTCP_bySeg, TPCP_bySeg, OPCP_bySeg, PRCP_bySeg, SGCN_bySeg, RICE_bySeg, NVGT_bySeg, AQUA_bySeg, PSTR_bySeg, URBN_bySeg, RLOS_bySeg, WTLD_bySeg, STFL_bySeg, BDSS_bySeg, WDSB_bySeg, HRSB_bySeg, NFRS_bySeg, SVNN_bySeg, GRLD_bySeg, FRST_bySeg)

# adding the conversion area for all LULC to region:

cnvArea_region <- areaLULC_region_missing %>%
  group_by(id) %>%
  summarize(total = sum (total_cnvArea))

# creating a variable referring to loss not identified in any LULC addressed in this work:

OTHER_bySeg <- data.frame(totalArea_loss_region$total_loss_seg - cnvArea_region$total)
OTHER_bySeg <- rename(OTHER_bySeg, total_cnvArea =   totalArea_loss_region.total_loss_seg...cnvArea_region.total)
OTHER_bySeg$Class <- c("others", "others", "others", "others", "others", "others", "others")
OTHER_bySeg$Class <- as.factor(OTHER_bySeg$Class)
OTHER_bySeg$id <- c("1", "2", "3", "4", "5", "6", "7")
OTHER_bySeg$id <- as.factor(OTHER_bySeg$id)
OTHER_bySeg <- OTHER_bySeg %>% select(id, total_cnvArea, Class)
OTHER_bySeg

# grouping all dataframes:

areaLULC_region = rbind(areaLULC_region_missing, OTHER_bySeg)

View(areaLULC_region)

# summing all conversion area by region:

cnvTotalArea_region = areaLULC_region %>%
  group_by(id, Class) %>%
  summarize(total = sum (total_cnvArea)) 

# calculating the percentage of each LULC for each region:

pctLULC_region = cnvTotalArea_region %>%  
  group_by(id) %>%
  mutate(percentage = (total/sum(total))*100) %>% 
  mutate(total = sprintf("%.1f", percentage)) # add decimal numbers

# turning into a numerical fact:

pctLULC_region$percentage <- as.numeric(pctLULC_region$percentage)

# defining colors for LULCs:

class_colors <- c("forest" = "#228B22",               # ForestGreen
                  "grassland" = "#32CD32",            # LimeGreen
                  "savanna" = "#7FFF00",              # Chartreuse
                  "nonForest" = "#8FBC8F",            # DarkSeaGreen
                  "herbSandbank" = "#FFB6C1",         # LightPink
                  "woodSandbank" = "#F08080",         # LightCoral
                  "bdss" = "#DC143C",                 # Crimson
                  "saltFlat" = "#7FFFD4",             # Aquamarine
                  "wetland" = "#66CDAA",              # MediumAquamarine
                  "rlo" = "#008080",                  # Teal
                  "urban" = "#363636",                # grey21
                  "pasture" = "#808080",              # Gray
                  "aquaculture" = "#C0C0C0",          # Silver
                  "nonVegetation" = "#DCDCDC",        # Gainsboro
                  "rice" = "#BDB76B",                 # DarkKhaki
                  "sugarCane" = "#DAA520",            # Goldenrod
                  "pereCrop" = "#8B4513",             # SaddleBrown
                  "otherPereCrop" = "#B8860B",        # DarkGoldenrod
                  "tempCrop" = "#A0522D",             # Sienna
                  "otherTempCrop" = "#CD853F",        # Peru
                  "others" = "#7B68EE")               # MediumSlateBlue

# defining order for LULCs:

pctLULC_region <- pctLULC_region %>%
  mutate(Class = factor(Class, levels = c("forest", 
                                          "grassland", 
                                          "savanna",
                                          "nonForest",
                                          "herbSandbank",
                                          "woodSandbank",
                                          "bdss",
                                          "saltFlat",
                                          "wetland",
                                          "rlo",
                                          "urban",
                                          "pasture",
                                          "aquaculture",
                                          "nonVegetation",
                                          "rice",
                                          "sugarCane",
                                          "pereCrop",
                                          "otherPereCrop",
                                          "tempCrop",
                                          "otherTempCrop",
                                          "others")))

# data ordering:

pctLULC_region_order <- pctLULC_region %>%
  arrange(id, Class)

pctLULC_region_order$id <- reorder(pctLULC_region_order$id, desc(pctLULC_region_order$id))

# bar chart representing the percentage contribution of each LULC to mangrove conversion:

ggplot(pctLULC_region_order, aes(x = factor(id), y = percentage, fill = Class)) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = ifelse(percentage > 1.9999999, paste0(round(percentage), "%"), "")), 
                position = position_stack(vjust = 0.5), size = 3.5, color = "black", fontface = "bold")+
  labs(x = "Region", y = "Percentage") +
  scale_fill_manual(values = class_colors) + 
  theme_minimal() +
  theme(legend.position = "right") +
  coord_flip()

# for states:

FRST_byState <- FRST_by_state %>% mutate(Class = "forest")
GRLD_byState <- GRLD_by_state %>% mutate(Class = "grassland")
SVNN_byState <- SVNN_by_state %>% mutate(Class = "savanna")
HRSB_byState <- HRSB_by_state %>% mutate(Class = "herbSandbank")
WDSB_byState <- WDSB_by_state %>% mutate(Class = "woodSandbank")
NFRS_byState <- NFRS_by_state %>% mutate(Class = "nonForest")
NVGT_byState <- NVGT_by_state %>% mutate(Class = "nonVegetation")
BDSS_byState <- BDSS_by_state %>% mutate(Class = "bdss")
STFL_byState <- STFL_by_state %>% mutate(Class = "saltFlat")
WTLD_byState <- WTLD_by_state %>% mutate(Class = "wetland")
RLOS_byState <- RLOS_by_state %>% mutate(Class = "rlo")
URBN_byState <- URBN_by_state %>% mutate(Class = "urban")
SGCN_byState <- SGCN_by_state %>% mutate(Class = "sugarCane")
RICE_byState <- RICE_by_state %>% mutate(Class = "rice")
PRCP_byState <- PRCP_by_state %>% mutate(Class = "pereCrop")
OPCP_byState <- OPCP_by_state %>% mutate(Class = "otherPereCrop")
TPCP_byState <- TPCP_by_state %>% mutate(Class = "tempCrop")
OTCP_byState <- OTCP_by_state %>% mutate(Class = "otherTempCrop")
PSTR_byState <- PSTR_by_state %>% mutate(Class = "pasture")
AQUA_byState <- AQUA_by_state %>% mutate(Class = "aquaculture")

# adding the conversion area for all LULC to state:

areaLULC_state_missing = rbind(OTCP_byState, TPCP_byState, OPCP_byState, PRCP_byState, SGCN_byState, RICE_byState, NVGT_byState, AQUA_byState, PSTR_byState, URBN_byState, RLOS_byState, WTLD_byState, STFL_byState, BDSS_byState, WDSB_byState, HRSB_byState, NFRS_byState, SVNN_byState, GRLD_byState, FRST_byState)

cnvArea_state_all = areaLULC_state_missing %>%
  group_by(id) %>%
  summarize(total = sum (total_cnvArea)) 

OTHER_byState <- data.frame(totalArea_loss_state$total_loss_state - cnvArea_state_all$total)
OTHER_byState <- rename(OTHER_byState, total_cnvArea =   totalArea_loss_state.total_loss_state...cnvArea_state_all.total)
OTHER_byState$Class <- c("others", "others", "others", "others", "others", "others", "others",
                         "others", "others", "others", "others", "others", "others", "others",
                         "others", "others")
OTHER_byState$Class <- as.factor(OTHER_byState$Class)
OTHER_byState$id <- c("AP", "PA", "MA", "PI", "CE", "RN", "PB",
                      "PE", "AL", "SE", "BA", "ES", "RJ", "SP",
                      "PR", "SC")
OTHER_byState$id <- as.factor(OTHER_byState$id)
OTHER_byState <- OTHER_byState %>% select(id, total_cnvArea, Class)
OTHER_byState

# agrouping all dataframes

areaLULC_state = rbind(areaLULC_state_missing, OTHER_byState)

# summing all conversion area by state:

cnvArea_state = areaLULC_state %>%
  group_by(id, Class) %>%
  summarize(total = sum (total_cnvArea)) 

# calculating loss percentage for each state:

pctLULC_state = cnvArea_state %>%  
  group_by(id) %>%
  mutate(percentage = (total/sum(total))*100) %>% # percentage calculation
  mutate(total = sprintf("%.1f", percentage)) # changes "400." to "400.3" in total

pctLULC_state$percentage <- as.numeric(pctLULC_state$percentage)
View(percentage)

pctLULC_state <- pctLULC_state %>%
  mutate(Class = factor(Class, levels = c("forest", 
                                          "grassland", 
                                          "savanna",
                                          "nonForest",
                                          "herbSandbank",
                                          "woodSandbank",
                                          "bdss",
                                          "saltFlat",
                                          "wetland",
                                          "rlo",
                                          "urban",
                                          "pasture",
                                          "aquaculture",
                                          "nonVegetation",
                                          "rice",
                                          "sugarCane",
                                          "pereCrop",
                                          "otherPereCrop",
                                          "tempCrop",
                                          "otherTempCrop",
                                          "others")))

# rearrange the appearance of the states, from north to south:

pctLULC_state_order <- pctLULC_state %>%
  arrange(id, Class)

order_ids <- rev(c("AP", "PA", "MA", "PI", "CE", "RN", "PB", "PE", 
                   "AL", "SE", "BA", "ES", "RJ", "SP", "PR", "SC"))

pctLULC_state_order <- pctLULC_state_order %>%
  mutate(id_ordered = factor(id, levels = order_ids))

ggplot(pctLULC_state_order, aes(x = id_ordered, y = percentage, fill = Class)) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = ifelse(percentage > 1.9999999, paste0(round(percentage), "%"), "")), 
            position = position_stack(vjust = 0.5), size = 3.5, color = "black", fontface = "bold")+
  labs(x = "Region", y = "Percentage") +
  scale_fill_manual(values = class_colors) + 
  theme_minimal() +
  theme(legend.position = "right") +
  coord_flip()


# Brazil map
# ----------

# defining the coordinates of the limits of each region (segment)

latitude <- c(4.51, 1.67, -00.60, -2.25, -5.14, -13.00, -23.01, 29.33)
longitude <- c(-34.32, -34.32, -34.32, -34.32, -34.32, -34.32, -34.32, -34.32)
coord <- data.frame(lat = latitude, lon = longitude)

# importing shapefile from brazilian states
# é necessário extrair todos os documentos do zip e mante-los na diretorio

shpBr <- readOGR("C:/Users/Lab/Documents/Gabriel/analises-artigo", "BR_UF_2020", stringsAsFactors=FALSE, encoding="UTF-8")
plot(shpBr)
View(shpBr)

# assigning the names in a table

br_data <- slot(object = shpBr, name = "data");
View(br_data)

# selecting only the states of interest

list_states <- c("AP", "PA", "MA", "PI", "CE", "RN", "PB", "PE", 
                 "AL", "SE", "BA", "ES", "RJ", "SP", "PR", "SC");

# locating the indices of each state

numeric_index <- which(br_data$SIGLA_UF %in% list_states);
print(numeric_index);

# selecting the states of interest from their indexes

shp_states <- shpBr[numeric_index, ];
shp_states <- shp_states[order(list_states), ]

View(shp_states)

# extracting the abbreviations of the states in the same order as the defined list

acronym <- br_data$SIGLA_UF[match(list_states, br_data$SIGLA_UF)]

# calculating the center of each geometry (state) for subsequent acronyms and percentages

centroids <- gCentroid(shp_states, byid = TRUE)
centroids <- as.data.frame(centroids)
coord_centroids <- coordinates(centroids)
index_order <- order(as.numeric(rownames(centroids)))
coord_order <- coord_centroids[index_order, ]
coord_order[c(1, 2), ] <- coord_order[c(2, 1), ]

# calculating percentage of loss for each state:

pctLoss_state <- totalArea_loss_state %>% 
  mutate(percentage = (total_loss_state/sum(total_loss_state))*100)

# reorder id (north - south):

pctLoss_state <- pctLoss_state %>%
  arrange(factor(id, levels = list_states))

# keeping only one decimal place after the point

pctLoss_state$percentage <- round(pctLoss_state$percentage, 1)

# agrouping informations in one datafrane:

inf_map <- data.frame(lat = coord_order[,2],
                      lon = coord_order[,1],
                      acronym = acronym,
                      pct = pctLoss_state[,3])

# map:

plot(shp_states, col = "#F5F5F5", axes = TRUE, border = "black", 
     main = "Spatial Units - States and Segments") +
points(x = coord[,2], y = coord[,1], pch = 19, cex = 1.0) +
text(x = inf_map$lon, y = inf_map$lat, labels = inf_map$acronym, pos = 2.3, cex = 0.6) +
text(x = inf_map$lon, y = inf_map$lat, labels = paste0(inf_map$percentage, "%"), pos = 1.8, cex = 0.6, col = "black")

