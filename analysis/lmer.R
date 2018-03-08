# Set Working Directory
setwd("~/Desktop/dev/visual-encoding-effectiveness-paper/supplement_material/analysis")

# install.packages("lme4")
library(lme4)

responses = read.csv('../responses/responses.csv')

# factor
responses[, 'taskGroup'] <- as.factor(responses[, 'taskGroup'])
responses[, 'userID'] <- as.factor(responses[, 'userID'])
responses[, 'questionName'] <- as.factor(responses[, 'questionName'])
responses[, 'userChoice'] <- as.factor(responses[, 'userChoice'])
responses[, 'assignmentID'] <- as.factor(responses[, 'assignmentID'])
responses[, 'specID'] <- as.factor(responses[, 'specID'])
responses[, 'Q1'] <- as.factor(responses[, 'Q1'])
responses[, 'Q2'] <- as.factor(responses[, 'Q2'])
responses[, 'N'] <- as.factor(responses[, 'N'])
responses[, 'Q1_channel'] <- as.factor(responses[, 'Q1_channel'])
responses[, 'Q2_channel'] <- as.factor(responses[, 'Q2_channel'])
responses[, 'name_channel'] <- as.factor(responses[, 'name_channel'])
responses[, 'gender'] <- as.factor(responses[, 'gender'])
responses[, 'education'] <- as.factor(responses[, 'education'])
responses[, 'age'] <- as.factor(responses[, 'age'])
responses[, 'vision_deficiency'] <- as.factor(responses[, 'vision_deficiency'])
responses[, 'vision_impairment_description']  <- as.factor(responses[, 'vision_impairment_description'])
responses[, 'userAgent'] <- as.factor(responses[, 'userAgent'])
responses[, 'dataset'] <- as.factor(responses[, 'dataset'])
responses[, 'channel'] <- as.factor(responses[, 'channel'])
responses[, 'Q1_entropy_class'] <- as.factor(responses[, 'Q1_entropy_class'])
responses[, 'Q2_entropy_class'] <- as.factor(responses[, 'Q2_entropy_class'])
responses[, 'N_entropy_class'] <- as.factor(responses[, 'N_entropy_class'])
responses[, 'clusteredness_class'] <- as.factor(responses[, 'clusteredness_class'])
responses[, 'correlation_class'] <- as.factor(responses[, 'correlation_class'])
responses[, 'correctOption'] <- as.factor(responses[, 'correctOption'])
responses[, 'userChoice'] <- as.factor(responses[, 'userChoice'])


# numeric
responses[, 'completionTime'] <- as.numeric(responses[, 'completionTime'])
responses[, 'stimuliTurn'] <- as.numeric(responses[, 'stimuliTurn'])
responses[, 'questionDifficulty'] <- as.numeric(responses[, 'questionDifficulty'])
responses[, 'questionTurn'] <- as.numeric(responses[, 'questionTurn'])
responses[, 'Q1_entropy'] <- as.numeric(responses[, 'Q1_entropy'])
responses[, 'Q2_entropy'] <- as.numeric(responses[, 'Q2_entropy'])
responses[, 'Nentropy'] <- as.numeric(responses[, 'Nentropy'])
responses[, 'correlation'] <- as.numeric(responses[, 'correlation'])
responses[, 'cluster'] <- as.numeric(responses[, 'cluster'])
responses[, 'cardinality'] <- as.numeric(responses[, 'cardinality'])
responses[, 'nPerCategory'] <- as.numeric(responses[, 'nPerCategory'])
responses[, 'containerHeight'] <- as.numeric(responses[, 'containerHeight'])
responses[, 'containerWidth'] <- as.numeric(responses[, 'containerWidth'])
responses[, 'height'] <- as.numeric(responses[, 'height'])
responses[, 'width'] <- as.numeric(responses[, 'width'])
responses[, 'windowInnerHeight'] <- as.numeric(responses[, 'windowInnerHeight'])
responses[, 'windowInnerWidth'] <- as.numeric(responses[, 'windowInnerWidth'])
responses[, 'windowOuterHeight'] <- as.numeric(responses[, 'windowOuterHeight'])
responses[, 'windowOuterWidth'] <- as.numeric(responses[, 'windowOuterWidth'])
responses[, "windowScreenAvailHeight"] <- as.numeric(responses[, "windowScreenAvailHeight"])
responses[, "windowScreenAvailLeft"] <- as.numeric(responses[, "windowScreenAvailLeft"])
responses[, "windowScreenAvailTop"] <- as.numeric(responses[, "windowScreenAvailTop"])
responses[, "windowScreenAvailWidth"] <- as.numeric(responses[, "windowScreenAvailWidth"])
responses[, "windowScreenColorDepth"] <- as.numeric(responses[, "windowScreenColorDepth"])
responses[, "windowScreenHeight"] <- as.numeric(responses[, "windowScreenHeight"])
responses[, "windowScreenPixelDepth"] <- as.numeric(responses[, "windowScreenPixelDepth"])
responses[, "windowScreenWidth"] <- as.numeric(responses[, "windowScreenWidth"])

#Derived Variable
responses[, 'entropies'] <- as.factor(paste(responses[, 'Q1_entropy_class'], responses[, 'Q2_entropy_class'], "sep" = ""))
responses[, 'hasHorizontalScroll'] <- as.factor(ifelse(responses[, 'width'] > responses[, 'windowInnerWidth'],TRUE,FALSE))
responses[, 'hasVerticalScroll'] <- as.factor(ifelse(responses[, 'height'] > responses[, 'windowInnerHeight'],TRUE,FALSE))
responses[, 'browser'] <- as.factor(ifelse(grepl('Chrome',responses[, 'userAgent']) ,'Chrome',
  ifelse(grepl('Safari',responses[, 'userAgent']) ,'Safari',
  ifelse(grepl('Firefox',responses[, 'userAgent']) ,'Firefox', 'Others'))))
responses[, 'os'] <- as.factor(ifelse(grepl('Android',responses[, 'userAgent']) ,'Android',
  ifelse(grepl('Macintosh',responses[, 'userAgent']) ,'Macintosh',
  ifelse(grepl('Windows',responses[, 'userAgent']) ,'Windows',
  ifelse(grepl('CrOS',responses[, 'userAgent']) ,'CrOS',
  ifelse(grepl('Linux',responses[, 'userAgent']) ,'Linux',
  ifelse(grepl('iPad',responses[, 'userAgent']) ,'iPad',
  ifelse(grepl('iPhone',responses[, 'userAgent']) ,'iPhone', 'Others'))))))))
responses[, 'taskCategory'] <- as.factor(ifelse(responses[,'taskGroup'] =='compareAggregatedValue' | responses[,'taskGroup'] =='findExtremum', 'agg', 'val'))


# Target Variable
# responses[, 'isCorrect'] <- as.factor(ifelse(responses[, 'isCorrect']=='true', TRUE, FALSE))
responses[, 'isError'] <- as.factor(ifelse(responses[, 'isCorrect']!='true', TRUE, FALSE))
responses[, 'logCompletionTime'] <- as.numeric(log(responses[, 'completionTime']))
responses[, 'log2CompletionTime'] <- as.numeric(log2(responses[, 'completionTime']))
responses[, 'taskCategory'] <- as.factor(ifelse(responses[,'taskGroup'] =='compareAggregatedValue' | responses[,'taskGroup'] =='findExtremum', 'agg', 'val'))


responses$isPractice <- NULL
responses$surveyCode <- NULL
responses$startTime <- NULL
responses$endTime <- NULL
responses$status <- NULL
responses$question <- NULL
responses$options0 <- NULL
responses$options1 <- NULL
responses$stratum <- NULL
responses$specIDCorrect <- NULL

summary(responses)
summary(responses$isError)
#length(unique(responses$channel))

# Define optimizer
nlopt <- function(par, fn, lower, upper, control) {
    .nloptr <<- res <- nloptr(par, fn, lb = lower, ub = upper,
        opts = list(algorithm = "NLOPT_LN_BOBYQA", print_level = 1,
        maxeval = 1000, xtol_abs = 1e-6, ftol_abs = 1e-6))
    list(par = res$solution,
         fval = res$objective,
         conv = if (res$status > 0) 0 else res$status,
         message = res$message
    )
}

####################### Overall Model #####################

sTime <- proc.time()
model.overall.error <- glmer(isError ~ channel + questionTurn + stimuliTurn
  + (1 + channel | userID)
  + (1 | taskGroup)
  + (1 | assignmentID)
  , family='binomial'
  , control=glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
  , data = responses)
eTime <- proc.time()
eTime - sTime


sTime <- proc.time()
model.overall.time <- lmer(log2CompletionTime ~ channel + questionTurn + stimuliTurn
  + (1 + channel | userID)
  + (1 | taskGroup)
  + (1 | assignmentID)
  , control=lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
  , data = responses)
eTime <- proc.time()
eTime - sTime


####################### TaskCategoryWise Model #####################
subRes = responses[responses$taskGroup=='compareAggregatedValue' | responses$taskGroup=='findExtremum',];
sTime <- proc.time()
model.agg.error <- glmer(isError ~ channel + questionTurn + stimuliTurn
                             + (1 + channel | userID)
                             + (1 | taskGroup)
                             + (1 | assignmentID)
                             , family='binomial'
                             , control=glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
                             , data = subRes)
eTime <- proc.time()
eTime - sTime


sTime <- proc.time()
model.agg.time <- lmer(log2CompletionTime ~ channel + questionTurn + stimuliTurn
                           + (1 + channel | userID)
                           + (1 | taskGroup)
                           + (1 | assignmentID)
                           , control=lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
                           , data = subRes)
eTime <- proc.time()
eTime - sTime

subRes = responses[responses$taskGroup=='readValue' | responses$taskGroup=='compareValue',];
sTime <- proc.time()
model.val.error <- glmer(isError ~ channel + questionTurn + stimuliTurn
                         + (1 + channel | userID)
                         + (1 | taskGroup)
                         + (1 | assignmentID)
                         , family='binomial'
                         , control=glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
                         , data = subRes)
eTime <- proc.time()
eTime - sTime


sTime <- proc.time()
model.val.time <- lmer(log2CompletionTime ~ channel + questionTurn + stimuliTurn
                       + (1 + channel | userID)
                       + (1 | taskGroup)
                       + (1 | assignmentID)
                       , control=lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
                       , data = subRes)
eTime <- proc.time()
eTime - sTime

####################### Task-wise Model #####################
taskWiseErrorModels <- vector(mode="list", length=4);
taskWiseTimeModels <- vector(mode="list", length=4);
names(taskWiseErrorModels) <- c("compareAggregatedValue", "findExtremum", "compareValue", "readValue");
names(taskWiseTimeModels) <- c("compareAggregatedValue", "findExtremum", "compareValue", "readValue");

for (task in names(taskWiseErrorModels)) {
  subRes = responses[responses$taskGroup==task,];
  print(task);

  sTime <- proc.time();
  taskWiseErrorModels[[task]] <- glmer(isError ~ channel + questionTurn + stimuliTurn
    + (1 + channel | userID)
    + (1 | assignmentID)
    , family='binomial'
    , control=glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
    , data = subRes);
  eTime <- proc.time();
  print(eTime - sTime);

  sTime <- proc.time()
  taskWiseTimeModels[[task]] <- lmer(log2CompletionTime ~ channel + questionTurn + stimuliTurn
    + (1 + channel | userID)
    + (1 | assignmentID)
    , control=lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
    , data = subRes)
  eTime <- proc.time()
  print(eTime - sTime);
}

####################### Data-wise Model #####################
dataWiseErrorModels <- vector(mode="list", length=4);
dataWiseTimeModels <- vector(mode="list", length=4);
dataCharacteristics <- vector(mode="list", length=4);
names(dataWiseErrorModels) <- c( "Q1_entropy_class", "Q2_entropy_class", "cardinality", "nPerCategory");
names(dataWiseTimeModels) <- c( "Q1_entropy_class", "Q2_entropy_class", "cardinality", "nPerCategory");
names(dataCharacteristics) <- c( "Q1_entropy_class", "Q2_entropy_class", "cardinality", "nPerCategory");

dataCharacteristics[[1]] <- c("H","L");
dataCharacteristics[[2]] <- c("H","L");
dataCharacteristics[[3]] <- c(3, 10, 20);
dataCharacteristics[[4]] <- c(3, 30);

for (characteristic in names(dataCharacteristics)) {
# for (characteristic in c("Q1_entropy_class","Q2_entropy_class")) {
  print(characteristic)
  dataWiseErrorModels[[characteristic]] <- list();
  dataWiseTimeModels[[characteristic]] <- list();
  for (value in dataCharacteristics[[characteristic]]) {
    print(value);
    subRes = responses[responses[[characteristic]]==value,];

    sTime <- proc.time();
    dataWiseErrorModels[[characteristic]][[value]] <- glmer(isError ~ channel + questionTurn + stimuliTurn
      + (1 + channel | userID)
      + (1 | taskGroup)
      + (1 | assignmentID)
      , family='binomial'
      , control=glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
      , data = subRes);
    eTime <- proc.time();
    print(eTime - sTime);

    sTime <- proc.time()
    dataWiseTimeModels[[characteristic]][[value]] <- lmer(log2CompletionTime ~ channel + questionTurn + stimuliTurn
      + (1 + channel | userID)
      + (1 | taskGroup)
      + (1 | assignmentID)
      , control=lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
      , data = subRes)
    eTime <- proc.time()
    print(eTime - sTime);
  }
}

####################### Task-Data-wise Model #####################
taskdataWiseErrorModels <- vector(mode="list", length=4);
taskdataWiseTimeModels <- vector(mode="list", length=4);
names(taskdataWiseErrorModels) <- c("compareAggregatedValue", "findExtremum", "compareValue", "readValue");
names(taskdataWiseTimeModels) <- c("compareAggregatedValue", "findExtremum", "compareValue", "readValue");

for (task in names(taskWiseErrorModels)) {
  print(task);
  taskdataWiseErrorModels[[task]] <- vector(mode="list", length=5);
  names(taskdataWiseErrorModels[[task]]) <- c( "Q1_entropy_class", "Q2_entropy_class", "entropies", "cardinality", "nPerCategory");
  taskdataWiseTimeModels[[task]] <- vector(mode="list", length=5);
  names(taskdataWiseTimeModels[[task]]) <- c( "Q1_entropy_class", "Q2_entropy_class", "entropies", "cardinality", "nPerCategory");


  for (characteristic in names(dataCharacteristics)) {
  # for (characteristic in c("Q1_entropy_class","Q2_entropy_class")) {
    print(characteristic)
    taskdataWiseErrorModels[[task]][[characteristic]] <- list();
    taskdataWiseTimeModels[[task]][[characteristic]] <- list();

    for (value in dataCharacteristics[[characteristic]]) {
      print(value);
      subRes = responses[responses[[characteristic]]==value & responses$taskGroup==task,];

      sTime <- proc.time();
      taskdataWiseErrorModels[[task]][[characteristic]][[value]] <- glmer(isError ~ channel + questionTurn + stimuliTurn
        + (1 + channel | userID)
        + (1 | assignmentID)
        , family='binomial'
        , control=glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
        , data = subRes);
      eTime <- proc.time();
      print(eTime - sTime);

      sTime <- proc.time()
      taskdataWiseTimeModels[[task]][[characteristic]][[value]] <- lmer(log2CompletionTime ~ channel + questionTurn + stimuliTurn
        + (1 + channel | userID)
        + (1 | assignmentID)
        , control=lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
        , data = subRes)
      eTime <- proc.time()
      print(eTime - sTime);
    }
  }
}



####################### TaskCategory-Data-wise Model #####################
taskCategoryDataWiseErrorModels <- vector(mode="list", length=4);
taskCategoryDataWiseTimeModels <- vector(mode="list", length=4);
names(taskCategoryDataWiseErrorModels) <- c("agg", "val");
names(taskCategoryDataWiseTimeModels) <- c("agg", "val");

for (task in  c("agg", "val")) {
  print(task);
  taskCategoryDataWiseErrorModels[[task]] <- vector(mode="list", length=4);
  names(taskCategoryDataWiseErrorModels[[task]]) <- c( "Q1_entropy_class", "Q2_entropy_class", "cardinality", "nPerCategory");
  taskCategoryDataWiseTimeModels[[task]] <- vector(mode="list", length=4);
  names(taskCategoryDataWiseTimeModels[[task]]) <- c( "Q1_entropy_class", "Q2_entropy_class", "cardinality", "nPerCategory");


  for (characteristic in names(dataCharacteristics)) {
  # for (characteristic in c("Q1_entropy_class","Q2_entropy_class")) {
    print(characteristic)
    taskCategoryDataWiseErrorModels[[task]][[characteristic]] <- list();
    taskCategoryDataWiseTimeModels[[task]][[characteristic]] <- list();

    for (value in dataCharacteristics[[characteristic]]) {
      print(value);
      subRes = responses[responses[[characteristic]]==value & responses$taskCategory==task,];

      sTime <- proc.time();
      taskCategoryDataWiseErrorModels[[task]][[characteristic]][[value]] <- glmer(isError ~ channel + questionTurn + stimuliTurn
        + (1 + channel | userID)
        + (1 | assignmentID)
        + (1 | taskGroup)
        , family='binomial'
        , control=glmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
        , data = subRes);
      eTime <- proc.time();
      print(eTime - sTime);

      sTime <- proc.time()
      taskCategoryDataWiseTimeModels[[task]][[characteristic]][[value]] <- lmer(log2CompletionTime ~ channel + questionTurn + stimuliTurn
        + (1 + channel | userID)
        + (1 | assignmentID)
        + (1 | taskGroup)
        , control=lmerControl(optimizer = "nloptwrap", calc.derivs = FALSE)
        , data = subRes)
      eTime <- proc.time()
      print(eTime - sTime);
    }
  }
}

