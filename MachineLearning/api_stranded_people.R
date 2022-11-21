library(plumber)
library(caret)
library(jsonlite)
library(ipred)
library(e1071)
library(yaml)
library(dplyr)
library(tidyr)
library(lubridate)

#Generador de Logs
logge <- function(req, res){
  d <- Sys.time()
  y <-list('usuario' = Sys.getenv("USERNAME"),
           'end_point' = req$PATH_INFO,
           'user_agent'=req$HTTP_USER_AGENT,
           'time' = d, 
           'payload'=req$body, 
           'output' = res$body
  )
  archivo <- toJSON(y, force = TRUE)
  
  wd <- getwd()
  
  dir <- paste0(wd,"/logs","/year=", year(d), "/month=", month(d), "/day=", day(d))
  
  dir.create(dir, recursive = TRUE)
  
  write(archivo, file = paste0(dir,"/",as.integer(d),".json"), append = TRUE)
}


model <- readr::read_rds("tb_model.rds")
model$modelInfo

#* Procesamiento de data individual

#* @param stranded_class si el paciente se encontraba atado
#* @param age edad del paciente
#* @param care_home_ref_flag si fue referido de una casa hogar
#* @param medically_safe_flag si el paciente ya se encuentra a salvo
#* @param hcop_flag si es paciente del area de mayores
#* @param needs_mental_health_support_flag si necesita cuidados de salud mental
#* @param previous_care_in_last_12_month si ha contado con cuidados medicos recientemente
#* @param admit_date fecha de ingreso al hospital
#* @param frail_descrip fragilidad del paciente
#* @post /predict1

function(stranded_class, age, care_home_ref_flag, medically_safe_flag, hcop_flag, needs_mental_health_support_flag,
         previous_care_in_the_last_12_month, admit_date, frail_descrip){
  features <- data_frame(stranded_class,
                         age=as.integer(age),
                         care_home_ref_flag=as.integer(care_home_ref_flag),
                         medically_safe_flag=as.integer(medically_safe_flag),
                         hcop_flag=as.integer(hcop_flag),
                         needs_mental_health_support_flag=as.integer(needs_mental_health_support_flag),
                         previous_care_in_the_last_12_month=as.integer(previous_care_in_the_last_12_month),
                         admit_date=as.Date(admit_date),
                         frail_descrip
                         )
  out <- predict(model,features,type = "prob")
  out
}

#* Procesamiento de data en batches
#* @post /predict

function(req, res){
  
  resultado <- data.frame(predict(model, newdata = as.data.frame(req$body), type="prob"))
  res$body <- resultado
  logge(req,res)
  resultado
}

#* Carga de Datos y Metricas de performance
#* @post /test_data
function(req, res){
  test_data_file <- as.data.frame(req$body$file$parsed)
  test_data_file <- test_data_file %>% mutate(stranded_class = factor(stranded_class)) %>% drop_na()
  predict <- predict(model, test_data_file, type="raw")
  predict_probs <- predict(model, test_data_file, type="prob")
  predictions <- cbind(predict, predict_probs)
  db_append_table <- ConfusionTableR::binary_class_cm(predictions$predict, test_data_file[, names(test_data_file) %in% c("stranded_class")])
  
  data_csv_test <- db_append_table$record_level_cm %>% 
    select('Pred_Not.Stranded_Ref_Not.Stranded', 'Pred_Stranded_Ref_Not.Stranded', 'Pred_Not.Stranded_Ref_Stranded', 'Pred_Stranded_Ref_Stranded',
           'Balanced.Accuracy', 'Accuracy', 'Precision', 'Recall', 'Specificity')
  
  res$body <- data_csv_test
  logge(req,res)
  data_csv_test
}


#* @plumber
function(pr){
  pr %>% 
    pr_set_api_spec(yaml::read_yaml("api.yaml"))
}