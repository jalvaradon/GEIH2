/*
                   ALCALDÍA DISTRITAL DE BARRANQUILLA
				   
Tema: indicadores laborales
Objetivo: organizar bases GEIH para realizar análisis sobre los principales
indicadores del mercado laboral de Barranquilla AM y Distrito Barranquilla
Archivos utilizados: Microdatos GEIH por Área
				
Autor: Equipo investigaciones Alcaldía Barranquilla
Fecha: Mayo 8 de 2017

*/

/****************************** Pasos***************************************

1. Descargar las bases de la GEIH en la página del DANE (ANDA)
   http://formularios.dane.gov.co/Anda_4_1/index.php/catalog/MICRODATOS
2. Crear una carpeta. Se sugiere guardar los archivos en el directorio 
   C:\...\GEIH\2016\ y guardar los archivos descargados (mes).txt
3.   Pasar archivos de .txt a .dta (formato Stata)
4.   Pegar bases (append) de una misma categoria pero de diferentes meses
5.   Combinar bases de datos para crear una única base
6.   Factores de expansión (trimestre, anual)
7.   Calcular indicadores mercado laboral (desegregaciones)

****************************************************************************/

/* Luego de ubicar todas las carpetas de los meses en un único lugar, se 
procede a importar los archivos .txt y pasarlos a formato .dta */

/* Convenciones para cambio de nombres, se toma var y el mes
   Área - Características generales (Personas) = cg_(mes)
   Área - Desocupados = des_(mes)
   Área - Fuerza de trabajo = ft_(mes)
   Área - Inactivos = ina_(mes)
   Área - Ocupados = ocu_(mes)
   Área - Otras actividades y ayudas en la semana = sem_(mes)
   Área - Otros ingresos = oi_(mes)
   Área - Vivienda y Hogares = vh_(mes)
*/

*** LOOP para importar los archivos de un año, pasandolos de .txt --> .dta 

global mes Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre

*Caracteristicas Generales
foreach x of global mes {
import delimited "C:\Users\jalva\Desktop\GEIH2\2016/`x'.txt\Área - Características generales (Personas).txt", clear
save "C:\Users\jalva\Desktop\GEIH2\2016/cg_`x'.dta", replace
}
*Desocupados
foreach x of global mes {
import delimited "C:\Users\jalva\Desktop\GEIH2\2016/`x'.txt\Área - Desocupados.txt", clear
save "C:\Users\jalva\Desktop\GEIH2\2016/des_`x'.dta", replace
}
*Fuerza de trabajo
*** Ojo en ABRIL el archivo que se baja del DANE tiene un nombre diferente. Se debe corregir.
foreach x of global mes {
import delimited "C:\Users\jalva\Desktop\GEIH2\2016/`x'.txt\Área - Fuerza de trabajo.txt", clear
save "C:\Users\jalva\Desktop\GEIH2\2016/ft_`x'.dta"
}
*Inactivos
foreach x of global mes {
import delimited "C:\Users\jalva\Desktop\GEIH2\2016/`x'.txt\Área - Inactivos.txt", clear
save "C:\Users\jalva\Desktop\GEIH2\2016/ina_`x'.dta"
}
*Ocupados
foreach x of global mes {
import delimited "C:\Users\jalva\Desktop\GEIH2\2016/`x'.txt\Área - Ocupados.txt", clear
save "C:\Users\jalva\Desktop\GEIH2\2016/ocu_`x'.dta"
}
*Otras actividades
foreach x of global mes {
import delimited "C:\Users\jalva\Desktop\GEIH2\2016/`x'.txt\Área - Otras actividades y ayudas en la semana.txt", clear
save "C:\Users\jalva\Desktop\GEIH2\2016/sem_`x'.dta"
}
*Otros ingresos
foreach x of global mes {
import delimited "C:\Users\jalva\Desktop\GEIH2\2016/`x'.txt\Área - Otros ingresos.txt", clear
save "C:\Users\jalva\Desktop\GEIH2\2016/oi_`x'.dta"
}
*Vivienda y hogares
foreach x of global mes {
import delimited "C:\Users\jalva\Desktop\GEIH2\2016/`x'.txt\Área - Vivienda y Hogares.txt", clear
save "C:\Users\jalva\Desktop\GEIH2\2016/vh_`x'.dta"
}
clear
*
display "{hline}"

*Unir las bases de una misma categoria por mes, a una general del año(APPEND)
* cd sirve para identificar la carpeta en donde el programa toma los archivos
clear
cd C:\Users\jalva\Desktop\GEIH2\2016

*Área - Características generales (Personas) = cg_

local fnames: dir "." files "cg_*.dta"
foreach f of local fnames {
    append using `"`f'"', force
}   
save cg_2016, replace

clear

*Área - Desocupados = des_

local fnames: dir "." files "des_*.dta"
foreach f of local fnames {
    append using `"`f'"', force
}   
save des_2016, replace

clear

*Área - Fuerza de trabajo = ft_

local fnames: dir "." files "ft_*.dta"
foreach f of local fnames {
    append using `"`f'"', force
}   
save ft_2016, replace

clear

*Área - Inactivos = ina_

local fnames: dir "." files "ina_*.dta"
foreach f of local fnames {
    append using `"`f'"', force
}   
save ina_2016, replace

clear

*Área - Ocupados = ocu_

local fnames: dir "." files "ocu_*.dta"
foreach f of local fnames {
    append using `"`f'"', force
}   
save ocu_2016, replace

clear

*Área - Otras actividades y ayudas en la semana = sem_

local fnames: dir "." files "sem_*.dta"
foreach f of local fnames {
    append using `"`f'"', force
}   
save sem_2016, replace

clear

*Área - Otros ingresos = oi_

local fnames: dir "." files "oi_*.dta"
foreach f of local fnames {
    append using `"`f'"', force
}   
save oi_2016, replace

clear

*Área - Vivienda y Hogares = vh_

local fnames: dir "." files "vh_*.dta"
foreach f of local fnames {
    append using `"`f'"', force
}   
save vh_2016, replace

clear

display "{hline}"
		
*Identificar el tamaño de los archivos de acuerdo al número de observaciones

local fnames: dir "." files "*_2016.dta"
foreach f of local fnames {
    di as text _dup(59) "-"
	di "Observaciones"
	use `"`f'"'
	display _N " " `"`f'"' 
	di as text _dup(59) "-"
	clear
	} 
*		* Unir los archivos - combinarlos teniendo en cuenta las llaves (MERGE)
*Merge cg + ft
use cg_2016
merge 1:1 directorio secuencia_p orden using ft_2016
drop _merge
save cgft_2016
clear

*Merge cg + ft + ocu
use cgft_2016
merge 1:1 directorio secuencia_p orden using ocu_2016
drop _merge
save cgftocu_2016
clear

*merge cg + ft + ocu + vh
***** Preguntar si así es correcto hacer el cruce de variables
use cgftocu_2016
merge m:m directorio secuencia_p using vh_2016
drop _merge
save cgftocuvh_2016
clear

*merge cg + ft + ocu + vh + sem
use cgftocuvh_2016
merge 1:1 directorio secuencia_p orden using sem_2016
drop _merge
save cgftocuvhsem_2016
clear

*merge cg + ft + ocu + vh + sem + oi
use cgftocuvhsem_2016
merge 1:1 directorio secuencia_p orden using oi_2016
drop _merge
save cgftocuvhsemoi_2016
clear

*merge cg + ft + ocu + vh + sem + oi + ina
use cgftocuvhsemoi_2016
merge 1:1 directorio secuencia_p orden using ina_2016
drop _merge
save cgftocuvhsemoiina_2016
clear

*merge cg + ft + ocu + vh + sem + oi + ina + des : Base Completa
use cgftocuvhsemoiina_2016
merge 1:1 directorio secuencia_p orden using des_2016
drop _merge
save basecompleta_2016
clear

display "{hline}"

* Calculo Indicadores Mercado Laboral

local fecha `c(current_date)'
local hora `c(current_time)'
local vers `c(stata_version)'
local flav = cond(`c(MP)', "MP", cond(`c(SE)', "SE", "IC"))
local cwd `c(pwd)'

display _newline "Calculos realizados el `fecha' a las `hora' en Stata/`flav' version `vers'"
display _newline "Los resultados estan alojados en: `cwd'"

display "{hline}"

use basecompleta_2016

*Clasificar datos por trimestres
gen trim = irecode(mes, 3, 6, 9, 12)
label define trimestre 0 "enero - marzo" 1 "abril - junio" 2 "julio - septiembre" 3 "octubre - diciembre"
label values trim trimestre
tab trim

*Clasificar datos por areas (ciudades) - etiqueta
label define ciudades 5 "Medellín" 8 "Barranquilla" 11 "Bogotá" 13 "Cartagena" 17 "Manizales" 23 "Monteria" 50 "Villavicencio" 52 "Pasto" 54 "Cúcuta" 66 "Pereira" 68 "Bucaramanga" 73 "Ibagué" 76 "Cali"
label values area ciudades
tab area

*Clasificar datos por sexo - etiqueta
label define sexo 1 "hombre" 2 "mujer"
label values p6020 sexo
tab p6020

*Clasificar datos por rangos de edad
gen rangoedad = irecode(p6040, 11, 24, 34, 44, 54, 65)
label define edades 0 "menor 12 años" 1 "12 - 24 años" 2 "25 - 34 años" 3 "35 - 44 años" 4 "45 - 54 años" 5 "55 - 65 años" 6 "mayor 65 años"
label values rangoedad edades
tab rangoedad

*Clasificar datos por nivel educativo - etiqueta
label define educacion 1 "Ninguno" 2 "Bachiller" 3 "Técnico o tecnológico" 4 "Universitario" 5 "Postgrado" 9 "No sabe, no informa"
label values p6220 educacion
tab p6220

*Factores de expansión: 
*Es la capacidad que tiene un individuo para representar el universo de estudio
*La variable en GEIH es fex_c_2011
*Dividir el Factor de expansión entre el número de meses

*Factor de expansión representatividad trimestral
gen FEX3= fex_c_2011/3
*Factor de expansión representatividad anual
gen FEX12= fex_c_2011/12

* Calculo PET (Población en edad de trabajar)
*utilizar la variable p6040 correspondiente a la edad 
gen pet = (p6040 >= 12)
*Para sacar estadisticas descriptivas (% PET)
tab pet

* Población ocupada
gen ocupado=1 if (p6240==1 | p6250==1 | p6260==1 | p6270==1)
tab ocupado
tab oci
*Debe ser lo mismo oci = ocupado (para verificar pegado de bases)

* Numero de desempleados
gen desempleo=1 if p6351==1
tab desempleo

*Calculo Población económicamente activa (PEA)
gen pea=1 if ocupado==1 | desempleo==1
tab pea

save basecalculos_2016

********************************************************************************
********************************************************************************

* CALCULO DE INDICADORES LABORALES

* Verificar que el resultado debe ser igual al que publica el DANE

*Calculo Población en edad de trabajar para Bogotá (anual)
tabstat FEX12 if area==11, by (pet) sta (sum) format (%9.0f)

*Cálculo Población en edad de trabajar para AM Barranquilla (anual)
tabstat FEX12 if area==08, by (pet) sta (sum) format (%9.0f)

*Calculo Población en edad de trabajar para AM Barranquilla (trimestre)
tabstat FEX3 if area==8&pet==1, statistics( sum ) by(trim) nototal format (%9.0f)

********************************************************************************
*Por trimestre, para todas las áreas: PET
* Pasos para pasar a Excel los resultados - Pob Edad de Trabajar
table trim area if pet==1, contents(sum FEX3 ) by(pet) format (%9.0f) replace name(pet)
sort area trim
export excel using "C:\Users\jalva\Desktop\GEIH2\2016\resultados.xls", sheet("pet") firstrow(varlabels)
clear

********************************************************************************
********************************************************************************

use basecalculos_2016

*Calculo número de ocupados para Bogotá (anual)
tabstat FEX12 if area==11, by (ocupado) sta (sum) format (%9.0f)

*Calculo número de ocupados para AM Barranquilla (anual)
tabstat FEX12 if area==08, by (oci) sta (sum) format (%9.0f)

*Calculo número de ocupados para AM Barranquilla (trimestral)
tabstat FEX3 if area==08&oci==1, by (trim) sta (sum) format (%9.0f) nototal

********************************************************************************
*Por trimestre, para todas las áreas: OCUPADOS
* Pasos para pasar a Excel los resultados - ocupados
table trim area if oci==1, contents(sum FEX3 ) by(oci) format (%9.0f) replace name(oci)
sort area trim
export excel using "C:\Users\jalva\Desktop\GEIH2\2016\resultados.xls", sheet("ocu") firstrow(varlabels)
clear

********************************************************************************
********************************************************************************

use basecalculos_2016

* Calculo desempleo Bogotá - anual
tabstat FEX12 if area==11, by (desempleo) sta (sum) format (%9.0f)

* Calculo desempleo Barranquilla - anual
tabstat FEX12 if area==08, by (desempleo) sta (sum) format (%9.0f)

********************************************************************************
*Por trimestre, para todas las áreas: DESEMPLEO
* Pasos para pasar a Excel los resultados
table trim area if desempleo==1, contents(sum FEX3 ) by(desempleo) format (%9.0f) replace name(oci)
sort area trim
export excel using "C:\Users\jalva\Desktop\GEIH2\2016\resultados.xls", sheet("des") firstrow(varlabels)
clear

********************************************************************************
********************************************************************************

use basecalculos_2016

*Calculo Población económicamente activa (PEA) Bogotá
tabstat FEX12 if area==11, by (pea) sta (sum) format (%15.0f)

*Calculo Población económicamente activa (PEA) Barranquilla
tabstat FEX12 if area==08, by (pea) sta (sum) format (%15.0f)

********************************************************************************
*Por trimestre, para todas las áreas: POB ECONOMICAMENTE ACTIVA
* Pasos para pasar a Excel los resultados
table trim area if pea==1, contents(sum FEX3 ) by(pea) format (%9.0f) replace name(oci)
sort area trim
export excel using "C:\Users\jalva\Desktop\GEIH2\2016\resultados.xls", sheet("pea") firstrow(varlabels)
clear

********************************************************************************
********************************************************************************

use basecalculos_2016

*******************************************************************************
*** Calculo número de desempleados por nivel educativo ***

   /* p6220 / mayor nivel educativo / 
   Ninguno = 1 
   Bachiller = 2 
   Técnico o tecnológico = 3
   Universitario = 4
   Postgrado = 5
   No sabe, no informa = 9
*/

forvalues i=1 (1) 5{
use basecalculos_2016
display " nivel educativo " `i'
table trim area if (p6220==`i'), contents(sum FEX3) by (desempleo) format (%9.0f) replace name(des_`i')
sort area trim
export excel using "C:\Users\jalva\Desktop\GEIH2\2016\resultados.xls", sheet(des_`i') firstrow(varlabels)
clear
}

********************************************************************************
*** Calculo de ocupados por nivel educativo ***

use basecalculos_2016

forvalues i=1 (1) 5{
use basecalculos_2016
display " nivel educativo " `i'
table trim area if (p6220==`i'), contents(sum FEX3) by (oci) format (%9.0f) replace name(ocu_`i')
sort area trim
export excel using "C:\Users\jalva\Desktop\GEIH2\2016\resultados.xls", sheet(ocu_`i') firstrow(varlabels)
clear
}
*


********************************************************************************
********************************************************************************
*************************** por revisar ****************************************
********************************************************************************
*************************** mejorar codigo *************************************

*PET Hombres

*Cálculo Población en edad de trabajar para Barranquilla (hombres)
gen pet_hombre = (pet==1&p6020==1)
tabstat FEX12 if area==08 , by (pet_hombre) sta (sum) format (%9.0f)

*Ocupados Hombres Barranquilla
gen oci_hombre= (oci==1&p6020==1)
tabstat FEX12 if area==08 , by (oci_hombre) sta (sum) format (%9.0f)

*Cálculo Población en edad de trabajar para Barranquilla (mujeres)
gen pet_mujer = (pet==1&p6020==2)
tabstat FEX12 if area==08 , by (pet_mujer) sta (sum) format (%9.0f)

*Ocupados Mujeres Barranquilla
gen oci_mujer= (oci==1&p6020==2)
tabstat FEX12 if area==08 , by (oci_mujer) sta (sum) format (%9.0f)

display "{hline}"

* Dudas: Calculo de los errores: ¿cómo saber si lo que calculé es correcto?
* Es decir, estadisticamente significativo.


**************************** OTROS ********************************************

*En el caso de trabajar cabecera y resto
*replace pet=1 if p6040>=12 & clase=="1"
*replace pet=1 if p6040>=10 & clase=="2"

*Calculo de desempleo por rango de edad

*generar dummy edad

gen edad_2030= 0
replace edad_2030 = 1 if (p6040>=20 & p6040<= 30)

*verificar sea de al menos el 10% del PET para que sea valido
sum edad_2030 if edad_2030==1
sum pet if pet==1

* Calculo desempleo Barranquilla (72)
tabstat FEX if (area==08 & edad_2030==1), by (desempleo) sta (sum) format (%15.0f)

*pea AMB entre 20 y 30 años
sum pea if (edad_2030==1 & area==08)

*variable de rango edad****
gen r_edad=0
replace r_edad=1 if (p6040== 12/25)
replace r_edad=2 if (p6040>=12 & p6040<= 25)
replace r_edad=3 if (p6040>=40 & p6040<= 50)
replace r_edad=4 if (p6040>=50 & p6040<= 60)
replace r_edad=5 if (p6040>60)

***************************************

* Calculo desempleo Bogotá (408)
tabstat FEX if area==11, by (desempleo) sta (sum) format (%15.0f)
*sin nivel educativo
tabstat FEX if (area==11 & p6220==1), by (desempleo) sta (sum) format (%15.0f)
*bachiller
tabstat FEX if (area==11 & p6220==2), by (desempleo) sta (sum) format (%15.0f)
*técnico
tabstat FEX if (area==11 & p6220==3), by (desempleo) sta (sum) format (%15.0f)
*universitario
tabstat FEX if (area==11 & p6220==4), by (desempleo) sta (sum) format (%15.0f)
*postgrado
tabstat FEX if (area==11 & p6220==5), by (desempleo) sta (sum) format (%15.0f)

* Calculo desempleo Barranquilla (72)
tabstat FEX if area==08, by (desempleo) sta (sum) format (%15.0f)
*sin nivel educativo
tabstat FEX if (area==08 & p6220==1), by (desempleo) sta (sum) format (%15.0f)
*bachiller
tabstat FEX if (area==08 & p6220==2), by (desempleo) sta (sum) format (%15.0f)
*técnico
tabstat FEX if (area==08 & p6220==3), by (desempleo) sta (sum) format (%15.0f)
*universitario
tabstat FEX if (area==08 & p6220==4), by (desempleo) sta (sum) format (%15.0f)
*postgrado
tabstat FEX if (area==08 & p6220==5), by (desempleo) sta (sum) format (%15.0f)


*¿Cuantos ocupados hay en el hogar?
bysort directorio secuencia_p : egen ocupados_h=total(oci)

*Porcentaje de ocupados por hogar por ciudad
tab ocupados_h area, column nofreq

*******************************************************************************
** CONVENCIONES ** 

 /* Medellín = 05
   Barranquilla = 08
   Bogotá = 11
   Cartagena = 13
   Manizales 17
   Monteria = 23
   Villavicencio = 50
   Pasto = 52
   Cúcuta = 54
   Pereira = 66
   Bucaramanga = 68
   Ibagué = 73
   Cali = 76 */ 
   
   /* p6220 / mayor nivel educativo / 
   Ninguno = 1 
   Bachiller = 2 
   Técnico o tecnológico = 3
   Universitario = 4
   Postgrado = 5
   No sabe, no informa = 9
*/
