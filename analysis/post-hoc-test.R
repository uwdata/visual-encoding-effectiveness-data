# Prerequisite : the result of lmer.R

library(multcomp)

# Set Working Directory
setwd("~/Desktop/dev/visual-encoding-effectiveness-paper/supplement_material/analysis")

dataCharacteristics <- vector(mode="list", length=4);
names(dataCharacteristics) <- c( "Q1_entropy_class", "Q2_entropy_class", "cardinality", "nPerCategory");
dataCharacteristics[[1]] <- c("H","L");
dataCharacteristics[[2]] <- c("H","L");
dataCharacteristics[[3]] <- c(3, 10, 20);
dataCharacteristics[[4]] <- c(3, 30);


print('overall.time');
model <- model.overall.time;
model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
s <- summary(model.tukey)
capture.output(s, file = "pairwise-comparison-results/overallTime.txt");

print('val.time');
model <- model.val.time;
model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
s <- summary(model.tukey)
capture.output(s, file = "pairwise-comparison-results/valTime.txt");

print('agg.time');
model <- model.agg.time;
model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
s <- summary(model.tukey)
capture.output(s, file = "pairwise-comparison-results/aggTime.txt");

####################### Task-wise Model #####################
for (task in c("compareAggregatedValue", "findExtremum", "compareValue", "readValue")) {
  print(task);
  model <- taskWiseTimeModels[[task]];
  model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
  s <- summary(model.tukey)
  capture.output(s, file = paste("pairwise-comparison-results/", task, "-Time.txt","sep" = ""));
}

####################### Data-wise Model #####################

for (characteristic in names(dataCharacteristics)) {
  print(characteristic)
  for (value in dataCharacteristics[[characteristic]]) {
    print(value);
    model <- dataWiseTimeModels[[characteristic]][[value]];
    model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
    s <- summary(model.tukey);
    capture.output(s, file = paste("pairwise-comparison-results/", characteristic,"-",value, "-Time.txt","sep" = ""));
  }
}

####################### Task-Data-wise Model #####################
for (task in names(taskWiseErrorModels)) {
  print(task);
  for (characteristic in names(dataCharacteristics)) {
    print(characteristic);
    for (value in dataCharacteristics[[characteristic]]) {
      print(value);
      model <- taskdataWiseTimeModels[[task]][[characteristic]][[value]];
      model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
      s <- summary(model.tukey);
      capture.output(s, file = paste("pairwise-comparison-results/", task,"-",characteristic,"-",value, "-Time.txt","sep" = ""));
    }
  }
}


####################### TaskCategory-Data-wise Model #####################
for (task in c("agg","val")) {
  print(task);
  for (characteristic in names(dataCharacteristics)) {
    print(characteristic);
    for (value in dataCharacteristics[[characteristic]]) {
      print(value);
      model <- taskCategoryDataWiseTimeModels[[task]][[characteristic]][[value]];
      model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
      s <- summary(model.tukey);
      capture.output(s, file = paste("pairwise-comparison-results/", task,"-",characteristic,"-",value, "-Time.txt","sep" = ""));
    }
  }
}










######ERROR########

print('overall.error');
model <- model.overall.error;
model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
s <- summary(model.tukey)
capture.output(s, file = "pairwise-comparison-results/overallError.txt");

print('val.error');
model <- model.val.error;
model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
s <- summary(model.tukey)
capture.output(s, file = "pairwise-comparison-results/valError.txt");

print('agg.error');
model <- model.agg.error;
model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
s <- summary(model.tukey)
capture.output(s, file = "pairwise-comparison-results/aggError.txt");

####################### Task-wise Model #####################
for (task in c("compareAggregatedValue", "findExtremum", "compareValue", "readValue")) {
  print(task);
  model <- taskWiseErrorModels[[task]];
  model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
  s <- summary(model.tukey)
  capture.output(s, file = paste("pairwise-comparison-results/", task, "-Error.txt","sep" = ""));
}

####################### Data-wise Model #####################
for (characteristic in names(dataCharacteristics)) {
  print(characteristic)
  for (value in dataCharacteristics[[characteristic]]) {
    print(value);
    model <- dataWiseErrorModels[[characteristic]][[value]];
    model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
    s <- summary(model.tukey);
    capture.output(s, file = paste("pairwise-comparison-results/", characteristic,"-",value, "-Error.txt","sep" = ""));
  }
}

####################### Task-Data-wise Model #####################
for (task in names(taskWiseErrorModels)) {
  print(task);
  for (characteristic in names(dataCharacteristics)) {
    print(characteristic);
    for (value in dataCharacteristics[[characteristic]]) {
      print(value);
      model <- taskdataWiseErrorModels[[task]][[characteristic]][[value]];
      model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
      s <- summary(model.tukey);
      capture.output(s, file = paste("pairwise-comparison-results/", task,"-",characteristic,"-",value, "-Error.txt","sep" = ""));
    }
  }
}


####################### TaskCategory-Data-wise Model #####################
for (task in c("agg","val")) {
  print(task);
  for (characteristic in names(dataCharacteristics)) {
    print(characteristic);
    for (value in dataCharacteristics[[characteristic]]) {
      print(value);
      model <- taskCategoryDataWiseErrorModels[[task]][[characteristic]][[value]];
      model.tukey <- glht(model, linfct=mcp(channel = "Tukey"));
      s <- summary(model.tukey);
      capture.output(s, file = paste("pairwise-comparison-results/", task,"-",characteristic,"-",value, "-Error.txt","sep" = ""));
    }
  }
}
