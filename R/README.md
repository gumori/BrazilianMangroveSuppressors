#  Time series analysis using R program
     
  Gabriel Tofanelo Vanin
  São Paulo State University, Institute of Biociences
  São Vicente-SP, 11330-900, Brazil
  biel.tofanelo@gamil.com

  Eduardo Ribeiro Lacerda
  International Institute for Sustainability
  Jardim Botânico-RJ, 2240-320, Brazil
  eduardolacerdageo@gmail.com

  Gustavo Maruyama Mori
  São Paulo State University, Institute of Biociences
  São Vicente-SP, 11330-900
  hustavo.mori@unesp.br

  Date of data collection: 2023/04
  language: english

#  Data Overview

Data and file overview

     allData.zip: zipped folder with 44 tables, including 'year', 'level', 'id', 'driver'.
      year refers to the date of area change detection, ranging from 2000 to 2020;
      level refers to spatial scale, regional scale and state scale;
      id refers to the specific geographic boundary of the level. Regions has 7 IDs, corresponding to seven latitudinal bands that divide the mangroves into regions with similar climatic and phytophysiognomic characteristics. States have 16 IDs, corresponding to the 16 Brazilian coastal federative units that have mangroves within their geographic limits;
      driver refers to the area of change in km² for different direct conversion factors, including all detected loss and gain. The 44 tables and their respective names refer to all drivers at regional and state scales;

    The data is in '.txt' format separated by '/'. The endings '_region' and '_states' indicate the scale of each table/file. Below are the file names and their respective drivers.
       aquaculture_region and aquaculture_state: shrimp and salt ponds;
       bdss_region and bdss_state: beach, dune and sand spot;
       forest_region and forest_state: forest formation;
       grassland_region and grassland_state: grassland formation;
       herbSandbank_region and herbSandbank_state: herbaceous sandbank vegetation;
       nonForest_region and nonForest_state: other non-forest formations;
       nonVegetation_region and nonVegetation_state: other non vegetation areas;
       otherPereCrop_region and otherPereCrop_state: other perennial crops;
       otherTempCrop_region and otherTempCrop_state: other temporary crops;
       pasture_region and pasture_crop: pasture;
       pereCrop_region and pereCrop_state: perennial crop;
       rice_region and rice_state: rice;
       rlo_region and rlo_state: river, lake and ocean;
       saltFlat_region and saltFlat_state: salt flat;
       savanna_region and savanna_state: savanna vegetation;
       sugarcane_region and sugarcane_state: sugarcane;
       tempCrop_region and tempCrop_state: temporary crop;
       urban_region and urban_state: urban areas;
       wetland_region and wetland_state: wetland;
       woodSandbank_region and woodSandbank_state: wooded sandbank;
       loss_region and loss_state: mangrove area loss, supression areas;
       gain_region and gain_state: mangrove area gain, new areas;

     The files were created in 2023/04 and revised in 2023/07

     BR_UF_2020.zip: zipped folder with georeferenced files, including shapefile of Brazilian states.
   The file can be downloaded at: https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html (Brasil --> Unidades da Federação)
   Last accessed on 2023/10/04
 
 script_ts-graph.R: script in R language for time series analysis and percentage graphs.
   language: R
   porpuse: Construct time series from 2000 to 2020 of mangrove area changes for different spatial scales. Also creation of percentage conversion graphs for different land uses and coverage and map of the different scales covered (regional and state).
   
   methods: We handled data on loss, gain and replacement of mangrove areas for each year from 2000 to 2020 and for each spatial scale using intrinsic R packages. We used the tsibble (Wang et al. 2020) and feats (O’Hara-Wild et al. 2023) packages to perform the time series analyses. The time series were extracted to obtain their individual components, such as trend and noise. This script also contains a bar graph of the percentage of mangrove conversion for each land use and cover for each spatial unit (regional and state). Finally, we created a map with the Brazilian states and georeferenced points of the latitudes that limit regions I to VII. We use other programs to finish viewing the graphics, such as inkscape.
   Results: time series and their components from 2000 to 2020 for each region and state. Bar graph with percentage contribution to the direct conversion of mangroves by different types of land use and cover. Map of the Brazilian coast with political and environmental limits.

#  References

Wang, E., Cook, D., Hyndman, R.J., 2020. A New Tidy Data Structure to Support Exploration and Modeling of Temporal Data. J. Comput. Graph. Stat. 29,
466–478. https://doi.org/10.1080/10618600.2019.1695624
O’Hara-Wild, M., Hyndman, R., Wang, E., Cook, D., Talagala, T., Chhay, L., 2023. feasts: Feature Extraction and Statistics for Time Series.


