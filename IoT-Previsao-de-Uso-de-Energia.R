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
# atributos não preditivos (parâmetros)


#############################################################################################

#################################### DICIONARIO DE DADOS ####################################

# date ->            Data no formato ano-mês-dia hora:minutos:segundos
# Appliances ->      Consumo de energia em Wh (Watt-Hora). Variavel Target.
# lights ->          Consumo de energia de luminárias (Wh)
# T1 ->              Temperatura na Cozinha (em Celsius)
# RH1 ->             Umidade Relativa na Cozinha (em %)
# T2 ->              Temperatura na Sala de Estar (em Celsius)
# RH2 ->             Umidade Relativa na Sala de Estar (em %)
# T3 ->              Temperatura na Lavanderia (em Celsius)
# RH3 ->             Umidade Relativa na Lavanderia (em %)
# T4 ->              Temperatura no Escritório (em Celsius)
# RH4 ->             Umidade Relativa no Escritório (em %)
# T5 ->              Temperatura no Banheiro (em Celsius)
# RH5 ->             Umidade Relativa no Banheiro (em %)
# T6 ->              Temperatura Externa Lado Norte (em Celsius)
# RH6 ->             Umidade Relativa Externa Lado Norte (em %)
# T7 ->              Temperatura na Sala de Passar Roupa (em Celsius)
# RH7 ->             Umidade Relativa na Sala de Passar Roupa (em %)
# T8 ->              Temperatura no Quarto do Adolescente (em Celsius)
# RH8 ->             Umidade Relativa no Quarto do Adolescente (em %)
# T9 ->              Temperatura no Quarto dos Pais (em Celsius)
# RH9 ->             Umidade Relativa no Quarto dos Pais (em %)
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
























