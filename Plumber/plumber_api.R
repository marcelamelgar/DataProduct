library(plumber)

#* @apiTitle Clase sobre el uso de plumber
#* @apiDescription En este api se implementaran varios 
#* endpoint que nos serviran para aprender el uso de plumber

#* Eco del input
#* @param msg Mensaje que vamos a repetir
#* @get /echo

function(msg=""){
  list(msg = paste0("El mensaje es: ",msg))
}

#* Histograma distribucion Normal
#* @serializer png
#* @param n total de numeros aleatorios
#* @param bins numero de bins
#* @get /plot

function(n = 100, bins = 15){
  rand <- rnorm(as.numeric(n))
  hist(rand, breaks = as.numeric(bins))
}

#* Suma de dos Parametros
#* @serializer unboxedJSON
#* @param x primer numero
#* @param y segundo numero
#* @get /suma

function(x = '1', y = '2'){
  x <- as.numeric(x)
  y <- as.numeric(y)
  list('Primer Numero' = x,
       'Segundo Numero' = y,
       'output' = x+y)
}

#* Ejemplo de serializacion csv
#* @serializer csv
#* @param n numero de filas
#* @get /data

function(n = '100'){
  head(mtcars, as.numeric(n))
}

