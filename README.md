# Modelagem Preditiva em IoT - Previsão de Uso de Energia

Este projeto de IoT tem como objetivo a criação de modelos preditivos para 
a previsão de consumo de energia de eletrodomésticos. Os dados utilizados 
incluem medições de sensores de temperatura e umidade de uma rede sem fio, 
previsão do tempo de uma estação de um aeroporto e uso de energia utilizada por
luminárias. 

O conjunto de dados foi coletado por um período de 10 minutos por cerca de
5 meses. As condições de temperatura e umidade da casa foram monitoradas com 
uma rede de sensores sem fio ZigBee. Cada nó sem fio transmitia as condições
de temperatura e umidade em torno de 3 min. Em seguida, a média dos dados foi
calculada para períodos de 10 minutos. Os dados de energia foram registrados
a cada 10 minutos com medidores de energia de barramento. O tempo da estação
meteorológica mais próxima do aeroporto (Aeroporto de Chievres, Bélgica) foi
baixado de um conjunto de dados públicos do Reliable Prognosis (rp5.ru) e mesclado
com os conjuntos de dados experimentais usando a coluna de data e hora. Duas variáveis
aleatórias foram incluídas no conjunto de dados para testar os modelos de
regressão e filtrar os atributos não preditivos (parâmetros).

Orientações:

- Dentro da pasta docs esta localizado o notebook utilizado durante o projeto, juntamente com a sua versão convertido para .html .
- Na pasta modelos possui outro readme.md com instruções de como baixar o modelo já treinado, esse não foi inclusi no repositorio devido a sua alta volumetria (mesmo compactado).
