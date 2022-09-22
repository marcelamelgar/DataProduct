library(plumber)
library(dplyr)
library(rpart)

#* @apiTitle Modelo del Titanic
#* @apiDescription Este api nos servira para predicir
#* si un pasajero del titanic sobrevive o no

fit <- readRDS("modelo_final.rds")

#* Prediccion de Sobrevivencia de un Pasajero
#* @param Pclass clase en el que viajabe el pasajero
#* @param Sex Sexo del pasajero
#* @param Age edad del pasajero
#* @param SibSp numero de hermanos
#* @param Parch numero de parientes
#* @param Fare precio del boleto
#* @param Embarked puerto del que embarco
#* @post /titanic

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