# -----------------------------------------------------------------
# Análise das áreas de manguezais perdidas nas últimas duas décadas
#------------------------------------------------------------------

# ...
# First: load working directory 
setwd("C:/Users/User/Downloads/")

# Next, import data for each method
data_lostArea <- read.table("lostArea_data.tsv", sep = "\t", header = T) #MapBiomas
dataHansen_lostArea <- read.table("lostArea_dataHansen.tsv", sep = "\t", header = T) #Hansen

# data checking
head(data_lostArea)   #inicio
tail(data_lostArea)   #fim
data_lostArea$ano     #somente a coluna 'ano'
print(data_lostArea)  #tudo

install.packages('Rcmdr')
library('Rcmdr')

par(mfrow=c(1,3)) #definindo gráfico com uma linha e três colunas

# First plot: Mapbiomas
plot(data_lostArea$ano, data_lostArea$area1n, type= "o", lwd = 2, col = 'darkorange',
     main = 'Perda de área de manguezais no Brasil - MapBiomas',
     xlab = 'Ano',
     ylab = 'Area (m²)',
     ylim = c(0,120))
lines(data_lostArea$ano, data_lostArea$area2n, type= 'o', lwd = 2, col = 'blue') #aqui, cada linha representa uma região (ver dados)
lines(data_lostArea$ano, data_lostArea$area3n, type= 'o', lwd = 2, col = 'sienna')
lines(data_lostArea$ano, data_lostArea$area4n, type= 'o', lwd = 2, col = 'yellow')
lines(data_lostArea$ano, data_lostArea$area5n, type= 'o', lwd = 2, col = 'green')
lines(data_lostArea$ano, data_lostArea$area6n, type= 'o', lwd = 2, col = 'red')
lines(data_lostArea$ano, data_lostArea$area7n, type= 'o', lwd = 2, col = 'purple1')

# Second plot: Hansen
plot(dataHansen_lostArea$ano, dataHansen_lostArea$area1n, type= "o", lwd = 2, col = 'darkorange',
     main = 'Perda de área de manguezais no Brasil - Hansen',
     xlab = 'Ano',
     ylab = 'Area (m²)',
     ylim = c(0,120))
lines(dataHansen_lostArea$ano, dataHansen_lostArea$area2n, type= 'o', lwd = 2, col = 'blue')
lines(dataHansen_lostArea$ano, dataHansen_lostArea$area3n, type= 'o', lwd = 2, col = 'sienna')
lines(dataHansen_lostArea$ano, dataHansen_lostArea$area4n, type= 'o', lwd = 2, col = 'yellow')
lines(dataHansen_lostArea$ano, dataHansen_lostArea$area5n, type= 'o', lwd = 2, col = 'green')
lines(dataHansen_lostArea$ano, dataHansen_lostArea$area6n, type= 'o', lwd = 2, col = 'red')
lines(dataHansen_lostArea$ano, dataHansen_lostArea$area7n, type= 'o', lwd = 2, col = 'purple1')
legend("topleft", c('area 1', 'area 2', 'area 3', 'area 4', 'area 5', 'area 6', 'area 7'),
       col = c('darkorange', 'blue', 'sienna', 'yellow', 'green', 'red', 'purple1'),
       pch = rep(20,20), x.intersp = 0.3, bty = "n", cex = 1.5, pt.cex = 2)

# ----------------------------------------------------
# Para o terceiro plot, devemos fazer a soma das áreas:

# Para isso, devemos somar todas regiões para cada ano
# *cada coluna representa uma regiao do Brasil!
# *cada linha representa um ano analisado!

print(data_lostArea) #para visualizar como os dados estão organizados

data_lostArea_sa <- data_lostArea[,-1] #aqui, tirei a primeira coluna (ano) para nao ser somado o valor 2001, 2002 etc
dataHansen_lostArea_sa <- dataHansen_lostArea[,-1] #mesma coisa para os dados Hansen

print(data_lostArea_sa) #visualização do resultado
print(dataHansen_lostArea_sa)

# Abaixo utilizei uma função de soma
# defini a soma somentes das linhas dos nossos dados utilizando 'MARGIN =1' 

perdaAnual <- apply(data_lostArea_sa,
                    FUN = sum,
                    MARGIN = 1)
print(perdaAnual) #visualização do resultado

# Fiz o mesmo para os dados Hansen
perdaAnual_han <- apply(dataHansen_lostArea_sa,
                    FUN = sum,
                    MARGIN = 1)
print(perdaAnual_han)

# --------------------------------------------------------------
# Com as somas realizadas, criei um novo banco de dados no excel
# Abaixo, plotei o último gráfico

perdaAnualBr <- read.table("soma_maphan.tsv", sep = "\t", header = T) #somas

#par(mfrow=c(1,1)) #para plotar somente este gráfico (lembrem que definimos no começo do código o plot de 3 gráficos)
plot(perdaAnualBr$ano, perdaAnualBr$somaMap , type= "o", lwd = 2, col = 'darkorange',
     main = 'Perda anual de área de manguezais no Brasil',
     xlab = 'Ano',
     ylab = 'Area (m²)',
     ylim = c(0,300))
lines(perdaAnualBr$ano, perdaAnualBr$somaHan, type= 'o', lwd = 2, col = 'blue')
legend("topleft", c('MapBiomas', 'Hansen'),
       col = c('darkorange', 'blue'),
       pch = rep(20,20), x.intersp = 0.3, bty = "n", cex = 1.0, pt.cex = 1.5)

#### Mudan�a do script pra teste do git