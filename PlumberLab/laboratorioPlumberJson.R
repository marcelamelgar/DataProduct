library(plumber)
library(lubridate)
library(dplyr)

#* @apiTitle Laboratorio Plumber
#* @apiDescription Nos servira para usar el feature forward to another handler

# Dynamic Routes - User & User ID

#  dataframe con la informacion de user y user id
users <- data.frame(
  uid=c(20200487,20200090),
  username=c("Marcela", "Rodrigo")
)

# segun el input en el path, brinda la informacion del usuario con el uder id brindado

#* Lookup a user
#* @get /users/<id>
function(id){
  subset(users, uid %in% id)
}

# csv con fechas de cumpleanos de companeros de clase
fechas <- read.csv("fechas.csv")
# se definen las fechas con formato de lubridate
fechas$Cumple <- mdy(fechas$Cumple)

#* @get /user/<from>/connect/<to>
function(from, to){
  #input brindado en el path con formato de lubridate
  from <- mdy(as.character(from))
  to <- mdy(as.character(to))
  # retorna las fechas que se encuentren dentro de la fecha from a la fecha to brindada en el path
  print(fechas %>%
          filter(Cumple >= from & Cumple <= to))
}

# Typed Dinamic Routes

# aqui especifico el tipo de valor que se ingresa en la ruta
#* @get /user/<id:int>
function(id){
  list(
    id = id,
    type = typeof(id)
  )
}

#* @post /user/activated/<active:bool>
function(active){
  if (!active){
    print("El usuario no esta activado")
  }
  else{
    print("El usuario esta activado")
  }
}

#* @get /user/charged/<price:double>
function(price){
  list(
    price = price,
    mensaje = 'suscripcion pagada'
  )
}

