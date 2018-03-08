  const d3 = require('d3'),
      fs = require('fs'),
      util = require('../stimuli/js/util.js'),
      csvtojson = require('csvtojson');

const measure = function(d){
    return {
      "logCompTime": Math.log2(d.completionTime),
      "error": d.isCorrect === 'true' ? 0 : 1
    };
  },
  iteration = Number(process.argv[3]) || 1000;

console.log("Started!");
let sTime = new Date();
csvtojson()
  .fromFile(process.argv[2])
  .on('end_parsed',data => {

  data.forEach(d => {
    d.dataset = d.assignmentID;
    d.spec = d.channel;
    d.taskCategory = taskCategory(d);
  });

  globalIDFactory = [
    {name: "spec" , method: d => [d.spec, "*", "*"].join("-")},
    {name: "spec_task" , method: d => [d.spec, "*", d.taskGroup].join("-")},
    {name: "spec_taskCategory" , method: d => [d.spec, "*", d.taskCategory].join("-")},
    {name: "spec_taskCategory_nPerCategory", method: d => [d.spec, d.nPerCategory, d.taskCategory].join("-")},
    {name: "spec_taskCategory_cardinality" , method: d => [d.spec, d.cardinality, d.taskCategory].join("-")},
    {name: "spec_taskCategory_Q1Entropy" ,     method: d => [d.spec, d.Q1_entropy_class, d.taskCategory].join("-")},
    {name: "spec_taskCategory_Q2Entropy" ,     method: d => [d.spec, d.Q2_entropy_class, d.taskCategory].join("-")}
  ];

  globalIDFactory.forEach(gSetID => {
    data.forEach(d => {
      d.globalSetID = gSetID.method(d);
    });

    console.log('LOADED DATA, COMPUTING BOOTSTRAPPED 95% CIs...');
    console.log((Date.now() - sTime)/1000);

    let results = bootstrap(data, iteration);

    console.log("DONE!: " + (Date.now() - sTime)/1000);
    let resultsArray = convert2Array(results);
    fs.writeFileSync(`${process.argv[3]}_${gSetID.name}.json`, JSON.stringify(resultsArray, null, 2));
  });
});







function bootstrap(data, iterN = 100) {
  let results = { "logCompTime": {}, "error": {}};


  let nestedData = d3.nest()
    .key(function(d) { return d.globalSetID; })
    .entries(data);


  nestedData.forEach( group => {
    let globalSetID = group.key;
    let subData = group.values;
    console.log("globalSetID : ", globalSetID, "...");

    let responsesPerUser = d3.nest()
      .key(function(d) { return d.turkerID; })
      .entries(subData);

    let participants = responsesPerUser.map(g => g.key).unique();
    for (let iter = 0; iter < iterN; ++iter) {

      let resampledParticipants = [];
      resampledParticipants = sample(participants.length, participants);

      let measures = resampledParticipants.reduce( (acc, turkerID) => {
        return acc = acc.concat(responsesPerUser.filter(g => g.key === turkerID)[0].values);
      }, []).map(measure);

      (results.logCompTime[globalSetID] || (results.logCompTime[globalSetID] = [])).push(d3.mean(measures, d=> d.logCompTime));
      (results.error[globalSetID] || (results.error[globalSetID] = [])).push(d3.mean(measures, d=> d.error));
    }
  });
  ["error", "logCompTime"].forEach(measure => {

    for (let seq in results[measure]) {
      let mu = d3.mean(results[measure][seq]),
          sd = d3.deviation(results[measure][seq]);
      results[measure][seq] = {mean: mu, lo:(mu-1.96*sd), hi:(mu+1.96*sd)};
    }
  });


  return results;
}

function convert2Array (results) {
  let converted = [];
  ["error", "logCompTime"].forEach(measure => {
    results[measure] = Object.keys(results[measure]).map(function(key){
      results[measure][key].globalSetID = key;
      return results[measure][key];
    });

    results[measure].forEach(function(d){

      found = converted.filter(f => f.globalSetID === d.globalSetID)[0];
      if (found) {
        found[measure + "-mean"] = d.mean;
        found[measure + "-lo"] = d.lo;
        found[measure + "-hi"] = d.hi;
      } else {
        let ids = d.globalSetID.split("-");
        let newR = {
          globalSetID: d.globalSetID,
          specName: ids[0],
          datasetName: ids[1],
          questionName: ids[2]
        };
        newR[measure + "-mean"] = d.mean;
        newR[measure + "-lo"] = d.lo;
        newR[measure + "-hi"] = d.hi;
        converted.push(newR);
      }
    });
  });


  return converted;
}



function sample(N, array){
  sampled = [];
  for (var i = 0; i < N; i++) {
    sampled.push(util.copy(array[Math.floor(Math.random()*array.length)]));
  }
  return sampled;
}

const taskCategory = function(d){
  if (["compareAggregatedValue", "findExtremum"].indexOf(d.taskGroup) >= 0) {
    return "Aggregate Task";
  }
  return "Value Task";
};
