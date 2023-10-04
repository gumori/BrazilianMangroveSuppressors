#  Geospatial analysis using Google Earth Engine program
     
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

#  Data and file Overview

     estados_BR.zip: zipped folder with georeferenced files, including shapefile of Brazilian states.
       The file can be downloaded at: https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html (Brasil --> Unidades da Federação)
       Last accessed on 2023/10/04
     
     script_geoespatial_GEE.txt: Text file of the script used for space-time analyzes within the Google Earth Engine (GEE) program.
       language: JavaScript
       porpuse: calculate changes in mangrove area in Brazil and at different spatial scales from 2000 to 2020.
       methods: land use and land cover mapping (LULC) was obtained from the MapBiomas database (collection 7.1), accessed through GEE (Gorelick et al. 2017). On this cloud-based platform, data was handled, selecting the years and LULC categories of interest. We also selected coastal states with mangroves (document Estados_BR.zip), and regions with similar climatic and phytophysiographic characteristics were created based on the latitudinal coordinates of their limits (Schaeffer-Novelli 1990), using the polygon tool. We apply GEE intrinsic functions to calculate area loss, area gain and area conversion for all explored LULC categories. Subsequently, each table was exported to a folder on the drive, one by one individually. The exported and treated tables are the documents found in the 'R' folder of this same repository. In the end, we created unique images for each year and LULC. Images are integrated by year and exported to the user's Assets. We built an interactive map based on annual images of direct conversion of mangroves present in Assets.
       Results: 44 tables of mangrove area changes and an interactive map from 2000 to 2020 of direct mangrove area conversions by 21 different LULC.

  #  References
      
     Schaeffer-Novelli, Y., Cintrón-Molero, G., Adaime, R. R., & de Camargo, T. M. (1990). Variability of mangrove ecosystems along the Brazilian coast. Estuaries, 13, 204-218.
     Gorelick, N., Hancher, M., Dixon, M., Ilyushchenko, S., Thau, D., & Moore, R. (2017). Google Earth Engine: Planetary-scale geospatial analysis for everyone. Remote sensing of Environment, 202, 18-27.

  #  links

     mapbiomas network: https://brasil.mapbiomas.org/
     mapbiomas forum: https://forum.mapbiomas.org/ 
     
