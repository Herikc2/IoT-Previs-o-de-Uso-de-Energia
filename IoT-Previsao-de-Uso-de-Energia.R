#################################### PROBLEMA DE NEGOCIO ####################################

# O conjunto de dados foi coletado por um 
# período de 10 minutos por cerca de 5 meses. As condições de temperatura e 
# umidade da casa foram monitoradas com uma rede de sensores sem fio ZigBee. 
# Cada nó sem fio transmitia as condições de temperatura e umidade em torno 
# de 3 min. Em seguida, a média dos dados foi calculada para períodos de 10 minutos. 

# Os dados de energia foram registrados a cada 10 minutos com medidores de 
# energia de barramento m. O tempo da estação meteorológica mais próxima do 
# aeroporto (Aeroporto de Chievres, Bélgica) foi baixado de um conjunto de dados 
# públicos do Reliable Prognosis (rp5.ru) e mesclado com os conjuntos de dados 
# experimentais usando a coluna de data e hora. Duas variáveis aleatórias foram 
# incluídas no conjunto de dados para testar os modelos de regressão e filtrar os 
# atributos não preditivos (parâmetros).


#############################################################################################

#################################### DICIONARIO DE DADOS ####################################

# date ->            Data no formato ano-mês-dia hora:minutos:segundos
# Appliances ->      Consumo de energia em Wh (Watt-Hora). Variavel Target.
# lights ->          Consumo de energia de luminárias em Wh (Watt-Hora)
# T1 ->              Temperatura na Cozinha em Celsius
# RH1 ->             Umidade Relativa na Cozinha em %
# T2 ->              Temperatura na Sala de Estar em Celsius
# RH2 ->             Umidade Relativa na Sala de Estar em %
# T3 ->              Temperatura na Lavanderia em Celsius
# RH3 ->             Umidade Relativa na Lavanderia em %
# T4 ->              Temperatura no Escritório em Celsius
# RH4 ->             Umidade Relativa no Escritório em %
# T5 ->              Temperatura no Banheiro em Celsius
# RH5 ->             Umidade Relativa no Banheiro em %
# T6 ->              Temperatura Externa Lado Norte em Celsius
# RH6 ->             Umidade Relativa Externa Lado Norte em %
# T7 ->              Temperatura na Sala de Passar Roupa em Celsius
# RH7 ->             Umidade Relativa na Sala de Passar Roupa em %
# T8 ->              Temperatura no Quarto do Adolescente em Celsius
# RH8 ->             Umidade Relativa no Quarto do Adolescente em %
# T9 ->              Temperatura no Quarto dos Pais em Celsius
# RH9 ->             Umidade Relativa no Quarto dos Pais em %
# T_out ->           Temperatura Externa em Celsius.
# Press_mm_hg ->     Pressão
# RH_out ->          Umidade Relativa Externa em %
# Windspeed ->       Velocidade do Vento em m/s
# Visibility ->      Visibilidade em km
# Tdewpoint ->       Ponto de Saturação em Celsius
# rv1 ->             Variável Randômica
# rv2 ->             Variável Randômica
# NSM ->             Número sequencial de medição
# WeekStatus ->      Indicativo de Dia da Semana ou Final de Semana
# Day_of_week ->     Indicativo de Segunda à Domingo

#############################################################################################


##################################### DEFININDO AMBIENTE ####################################

raiz_diretorio <- "C:/Users/herik/OneDrive/Documentos/GitHub/IoT-Previsao-de-Uso-de-Energia/data"
analises_diretorio <- "C:/Users/herik/OneDrive/Documentos/GitHub/IoT-Previsao-de-Uso-de-Energia/analises"
setwd(raiz_diretorio)
getwd()

### Bibliotecas
library(readr)
library(dplyr)
library(ggplot2)

### Datasets

dtTrain <- read_csv("training.csv")
dtTest <- read_csv("testing.csv") 

dtFull <- rbind(dtTrain, dtTest)

View(dtFull)

#################################### ANALISE EXPLORATORIA ###################################

# Aparentemente todas as colunas estão no formato correto, data esta no formato correto e as demais
# de ponto flutuantne também. Por ultimo as colunas do tipo Character/String estão no formato correto.
str(dtFull)
summary(dtFull)

# Contando ocorrencias da coluna WeekStatus, para saber quando ocorre o maior consumo de energia
dtTemp <- dtFull %>% 
  count(WeekStatus)

?scale_fill_brewer
ggplot() + geom_bar(data = dtTemp,
                    aes(x = "", y = n, fill = WeekStatus),
                    stat = "identity") +
  coord_polar("y", start = 0) +
  scale_fill_brewer(palette = "Blues") +
  theme_void() +
  ggtitle("Consumo em Dias Uteis e Finais de Semana")


setwd(analises_diretorio)
ggsave("Consumo em Dias Uteis e Finais de Semana.jpg", width = 10, height = 5)
setwd(raiz_diretorio)

# Contando ocorrecias da coluna WeekStatus por appliance para comparar o consumo de energia ao longo da semana
dtTemp <- dtFull %>%
  group_by(Appliances, WeekStatus) %>%
  count(Appliances) %>%
  filter(Appliances < 200)

View(dtTemp)

ggplot() + geom_bar(data= dtTemp,
                    aes(x = Appliances, y = n, fill = WeekStatus),
                    stat = "identity",
                    position = "dodge") +
  theme_bw() +
  scale_fill_brewer(palette = "Paired") +
  ggtitle("Consumo em Watt-Hora")

setwd(analises_diretorio)
ggsave("Consumo em Watt-Hora.jpg", width = 10, height = 5)
setwd(raiz_diretorio)


# Relação entre consumo de energia e temperatura na cozinha - Sem Arredondamento
dtTemp <- dtFull %>%
  count(T1, Appliances)

ggplot() + geom_point(data = dtTemp,
                      aes(x = T1, y = Appliances),
                      stat = "identity") +
  theme_bw() +
  scale_fill_brewer(palette = "Paired") +
  ggtitle("Consumo de Energia X Temperatura (Cozinha)")


relacao_energia_comodo = function(comodo_coluna, comodo_nome) {
  dtTemp <- dtFull %>%
    count(Temp = round(comodo_coluna), Appliances)
  
  ggplot() + geom_point(data = dtTemp,
                        aes(x = Temp, y = Appliances),
                        stat = "identity") +
    theme_bw() +
    scale_fill_brewer(palette = "Paired") +
    ggtitle(paste("Consumo de Energia X", comodo_nome))
}



# Relação entre consumo de energia e temperatura na cozinha
# Não é encontrado relação entre o aumento de temperatura na cozinha
relacao_energia_comodo(dtFull$T1, "Temperatura Cozinha")

setwd(analises_diretorio)
ggsave("Consumo de Energia X Temperatura (Cozinha).jpg", width = 10, height = 5)
setwd(raiz_diretorio)

# Relação entre consumo de energia e temperatura na Sala de Estar
# É perceptivel uma pequena relação entre o aumento de temperatura na sala de estar até os 22.5 grau celsius
# e o consumo de energia
relacao_energia_comodo(dtFull$T2, "Temperatura Sala de Estar")

setwd(analises_diretorio)
ggsave("Consumo de Energia X Temperatura (Sala de Estar).jpg", width = 10, height = 5)
setwd(raiz_diretorio)

# Relação entre consumo de energia e temperatura na Lavanderia
# É perceptivel um menor consumo de energia quando a temperatura é muito alta ou muito baixa na Lavanderia
relacao_energia_comodo(dtFull$T3, "Temperatura Lavanderia")

setwd(analises_diretorio)
ggsave("Consumo de Energia X Temperatura (Lavanderia).jpg", width = 10, height = 5)
setwd(raiz_diretorio)

# Relação entre consumo de energia e temperatura na Escritorio
# Abaixo de 18 graus celsius no escritorio assemelha ter uma diminuição no consumo de energia
relacao_energia_comodo(dtFull$T4, "Temperatura Escritorio")

setwd(analises_diretorio)
ggsave("Consumo de Energia X Temperatura (Escritorio).jpg", width = 10, height = 5)
setwd(raiz_diretorio)

# Relação entre consumo de energia e temperatura na Banheiro
# Não possui relação visual
relacao_energia_comodo(dtFull$T5, "Temperatura Banheiro")

setwd(analises_diretorio)
ggsave("Consumo de Energia X Temperatura (Banheiro).jpg", width = 10, height = 5)
setwd(raiz_diretorio)

# Relação entre consumo de energia e temperatura na Banheiro
# É perceptivel um menor consumo de energia quando a temperatura é muito alta ou muito baixa, assemelhando a uma normal
relacao_energia_comodo(dtFull$T6, "Temperatura Externa Lado Norte")

setwd(analises_diretorio)
ggsave("Consumo de Energia X Temperatura (ELN).jpg", width = 10, height = 5)
setwd(raiz_diretorio)

# Relação entre consumo de energia e temperatura na Banheiro
# Aparenta menor consumo quando a temperatura é menor igual a 15 graus celsius ou maior que 24 graus
relacao_energia_comodo(dtFull$T7, "Temperatura Sala de Passar Roupa")

setwd(analises_diretorio)
ggsave("Consumo de Energia X Temperatura (Sala de Passar Roupa).jpg", width = 10, height = 5)
setwd(raiz_diretorio)

# Relação entre consumo de energia e temperatura na Banheiro
# Aparenta menor consumo quando a temperatura é menor igual a 17.5 graus celsius ou maior que 26 graus
relacao_energia_comodo(dtFull$T8, "Temperatura Quarto do Adolescente")

setwd(analises_diretorio)
ggsave("Consumo de Energia X Temperatura (Quarto do Adolescente).jpg", width = 10, height = 5)
setwd(raiz_diretorio)


# Relação entre consumo de energia e temperatura na Banheiro
# Não possui relação visual
relacao_energia_comodo(dtFull$T9, "Temperatura Quarto dos Pais")

setwd(analises_diretorio)
ggsave("Consumo de Energia X Temperatura (Quarto dos Pais).jpg", width = 10, height = 5)
setwd(raiz_diretorio)

# Relação entre consumo de energia e temperatura na Banheiro
# Assemelhando-se a uma normal o sino começa a diminuir a temperatura quando menor que 5 graus ou maior que 17
relacao_energia_comodo(dtFull$T_out, "Temperatura Externa")

setwd(analises_diretorio)
ggsave("Consumo de Energia X Temperatura (Externa).jpg", width = 10, height = 5)
setwd(raiz_diretorio)

relacao_energia_comodo(dtFull$RH_out, "Temperatura Externa")

# Iremos remover features não relevantes como:
dtFull2 <- subset(dtFull, select = -c(NSM, rv1, rv2))
str(dtFull2)

# Boxplot
?boxplot

install.packages("psych")
library(moments)
library(psych)

psych.skew(dtFull2)

dtFull2 %>%
  group_by(date) %>%
  summarise(Skew = skewness(X), kurtosis(X))









































