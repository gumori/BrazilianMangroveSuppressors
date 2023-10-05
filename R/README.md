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

