# -*- coding: utf-8 -*-

"""
@author: Herikc Brecher
"""

from pickle import load
import streamlit as st
import pandas as pd
import sqlite3
from datetime import date


# Carregando modelo
pickle_model = open('modelo_iot_energia.pkl', 'rb')
modelo = load(pickle_model)
pickle_model.close()

# Carregando Scale
pickle_scale = open('scaler.pkl', 'rb')
scaler = load(pickle_scale)
pickle_scale.close()

# Conectando ao banco de dados sqlite
banco = sqlite3.connect('../database/banco.db')
cursor = banco.cursor()

st.cache()

# Prevendo Appliances
def prediction(NSM, Hour, Press_mm_hg, T3, T8, RH_3):

    dt = 'lights', 'T1', 'RH_1', 'T2', 'RH_2', 'T3', 'RH_3'  

    quantitativas = ['lights', 'T1', 'RH_1', 'T2', 'RH_2', 'T3', 'RH_3', 'T4',\
       'RH_4', 'T5', 'RH_5', 'T6', 'RH_6', 'T7', 'RH_7', 'T8', 'RH_8', 'T9',\
       'RH_9', 'T_out', 'Press_mm_hg', 'RH_out', 'Windspeed', 'Visibility',\
       'Tdewpoint', 'NSM']
   

    dt = {'lights': [1], 'T1': [1], 'RH_1': [1], 'T2': [1], 'RH_2': [1], 'T3': [T3], 'RH_3': [RH_3], 'T4': [1], 'RH_4': [1], 'T5': [1],\
          'RH_5': [1], 'T6': [1], 'RH_6': [1], 'T7': [1], 'RH_7': [1], 'T8': [T8], 'RH_8': [1], 'T9': [1], 'RH_9': [1], 'T_out': [1],\
              'Press_mm_hg': [Press_mm_hg], 'RH_out': [1], 'Windspeed': [1], 'Visibility': [1], 'Tdewpoint': [1], 'NSM': [NSM],\
                  'Weekend': [1], 'Day_of_week': [1], 'Month': [1], 'Day': [1], 'Hour': [Hour]} 

    dt = pd.DataFrame.from_dict(dt)
    
    # Padronizando dados
    dt_padronizado = dt.copy()
    dt_padronizado[quantitativas] = scaler.transform(dt[quantitativas])

    # Convertendo para dataframe
    dt_padronizado = pd.DataFrame(dt_padronizado.copy(), columns = dt.columns) 

    # Prevendo Appliances
    pred = modelo.predict(dt_padronizado[['T3', 'RH_3', 'T8', 'Press_mm_hg', 'NSM', 'Hour']])

    return pred


# -----------------------
'''
import sqlite3
from random import randrange, uniform

banco = sqlite3.connect('../database/banco.db')

cursor = banco.cursor()

data_l = ['01/12/2021', '02/12/2021', '03/12/2021', '04/12/2021', '05/12/2021', '06/12/2021', '07/12/2021', '08/12/2021', '09/12/2021', '10/12/2021', '11/12/2021', '12/12/2021', '13/12/2021', '14/12/2021', '15/12/2021', '16/12/2021', '17/12/2021', '18/12/2021', '19/12/2021', '20/12/2021', '21/12/2021', '22/12/2021', '23/12/2021', '24/12/2021', '25/12/2021', '26/12/2021', '27/12/2021', '28/12/2021', '29/12/2021', '30/12/2021']

n = 1000

for i in range(0, n):
    data = data_l[randrange(0, 30)]
    Hour = randrange(0, 24)
    Press_mm_hg = uniform(720, 780)
    T3 = uniform(17, 30)
    RH_3 = uniform(28, 51)  
    
    NSM = (24 - Hour) * 60 * 60
    T8 = T3 + 0.25
    
    result = prediction(NSM, Hour, Press_mm_hg, T3, T8, RH_3)

    cursor.execute("INSERT INTO previsao_energia VALUES ('" + str(data) + "', '" + str(Hour) + "', '" + str(Press_mm_hg) + "', '" + str(T3) + "', '" + str(RH_3) + "', '" + str(round(result[0], 2)) + "')")    
    banco.commit()   
'''
# -----------------------


def main():       
    # Front End
    html_temp = """ 
    <div style ="background-color: #03e3fc; padding: 15px; margin-bottom: 25px"> 
    
    <h1 style ="color:#333333;text-align:center;">Previsão de Energia</h1> 
    
    </div> 
    """
      
    # Display Front End
    st.markdown(html_temp, unsafe_allow_html = True) 
      
    # Inputs para o prediction
    #NSM = st.number_input("Segundos até a meia noite", 0, 86400, 0) 
    Hour = st.number_input("Hora do Dia", 0, 23, 0)
    Press_mm_hg = st.number_input("Pressão em mm/hg", 720.0, 780.0, 760.0, format = "%.2f")
    T3 = st.number_input("Temperatura Interna da Casa", 17.0, 30.0, 17.0, format = "%.2f")
    #T8 = st.number_input("Temperatura no Quarto dos Adolescente em graus Celsius", 16.0, 28.0, 16.0, format = "%.2f")
    RH_3 = st.number_input("Umidade Relativa Interna da Casa em %", 28.0, 51.0, 28.0, format = "%.2f")
    
    NSM = (24 - Hour) * 60 * 60
    T8 = T3 + 0.25
    
    result = ""
      
    # Executar preditor
    if st.button("Predict"): 
        result = prediction(NSM, Hour, Press_mm_hg, T3, T8, RH_3)
        msg = 'O consumo de energia as ' + str(Hour) + ' hora(s) é: ' + str(round(result[0], 2)) + 'Wh'
        st.success(msg)
        
        data = date.today().strftime("%d/%m/%Y")
        cursor.execute("INSERT INTO previsao_energia VALUES ('" + str(data) + "', '" + str(Hour) + "', '" + str(Press_mm_hg) + "', '" + str(T3) + "', '" + str(RH_3) + "', '" + str(round(result[0], 2)) + "')")    
        banco.commit()    
     
if __name__=='__main__': 
    main()
