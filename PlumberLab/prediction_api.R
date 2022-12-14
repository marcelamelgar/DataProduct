library(plumber)
library(lubridate)
library(jsonlite)
library(stringr)
library(dplyr)
library(rpart)

#* @apiTitle Modelo del Titanic
#* @apiDescription Este api nos servira para predicir
#* si un pasajero del titanic sobrevive o no


# Forward to Another Handdler

# registra el log del usuario al momento de ingresar
# manda su informacion y la guarda en un directorio en base al ano, mes, dia y hora en el que se ingreso
# tambien guarda la informacion que fue ingresada para despues poder prseguir a ver si el usuario hubiera sobrevivido

#* Log some information about the incoming request
#* @filter logger
function(req){
  largo <- length(req$args)
  if(largo > 0){
    fecha <- Sys.time()
    path <- paste0(getwd(),'/year=', year(fecha),'/month=', month(fecha),'/day=', day(fecha),'/',hour(fecha))
    path <- str_replace_all(path, fixed(" "), "")
    if (file.exists(path)) {
      
      cat("The folder already exists")
      
    } else {
      
      dir.create(path, recursive = TRUE)
      
    }
    
    ListJSON <- toJSON(list('req'=req$args, 'query'=req$QUERY_STRING, 'user_agent'=req$HTTP_USER_AGENT),auto_unbox=TRUE)
    write(ListJSON, file = paste0(path, '/', fecha, '.json'))
    plumber::forward()
    
  }
  plumber::forward()
}

fit <- readRDS("modelo_final.rds")

#parametros para la informacion del usuario

#* Prediccion de Sobrevivencia de un Pasajero
#* @param Pclass clase en el que viajabe el pasajero
#* @param Sex Sexo del pasajero
#* @param Age edad del pasajero
#* @param SibSp numero de hermanos
#* @param Parch numero de parientes
#* @param Fare precio del boleto
#* @param Embarked puerto del que embarco
#* @post /titanic

# funcion que predice si el usuario que se ingresa hubiera sobrevivido el titanic o no
function(Pclass, Sex, Age, SibSp, Parch, Fare, Embarked){
  features <- data_frame(Pclass = as.integer(Pclass),
                         Sex,
                         Age=as.integer(Age),
                         SibSp= as.integer(SibSp),
                         Parch = as.integer(Parch),
                         Fare = as.numeric(Fare),
                         Embarked)
  out <- predict(fit,features,type = "class")
  as.character(out)
}
