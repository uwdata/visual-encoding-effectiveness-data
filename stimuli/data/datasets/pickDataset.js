const fs = require('fs'),
      path = require('path'),
      baseDirs = [
        "10_30",
        "10_3",
        "20_30",
        "20_3",
        "3_3",
        "3_30"
      ],
      subDirs = ["HHH_H__W", "HLH_H__W", "LHH_H__W", "LLH_L__W"];
let results = [], idCount = 0;
const N = 12 * 8;
baseDirs.forEach(baseDir => {
  const metaData = JSON.parse(fs.readFileSync(baseDir + "/metaData_final_sample.json"));

  subDirs.forEach(subDir =>{
    let group = baseDir+"/"+subDir;
    let datasetFiles = fs.readdirSync(group);
    if (datasetFiles.length < N) {
      console.log("Need more data sets! : ", group, datasetFiles.length);
    }
    datasetFiles.forEach((file, i) => {
      if (i>= N) {
        fs.unlinkSync([baseDir, subDir, file].join('/'));
        return;
      }

      let dataCharacteristics = metaData.filter(md=> md.stat.metaData.id === Number(file.replace('data','').replace('.json','')))[0].stat;
      let newMeta = {
        "Q1": dataCharacteristics.metaData.uni_0,
        "Q2": dataCharacteristics.metaData.uni_1,
        "N": dataCharacteristics.metaData.uni_2,
        "Q1.entropy": dataCharacteristics.uni_0_entropy,
        "Q2.entropy": dataCharacteristics.uni_1_entropy,
        "Nentropy": dataCharacteristics.uni_2_entropy,
        "correlation": dataCharacteristics.bi_2_pearsonCor,
        "QQentropy": dataCharacteristics.qq_entropy,
        "cluster": dataCharacteristics.mul_clusteredness,
        "Q1.entropy_class": dataCharacteristics.uni_0_entropy_class,
        "Q2.entropy_class": dataCharacteristics.uni_1_entropy_class,
        "N.entropy_class": dataCharacteristics.uni_2_entropy_class,
        "clusteredness_class": dataCharacteristics.mul_clusteredness_class,
        "correlation_class": dataCharacteristics.bi_2_pearsonCor_class,
        "stratum": dataCharacteristics.stratum,
        "cardinality": dataCharacteristics.cardinality,
        "nPerCategory": Number(/_([0-9]*)$/g.exec(baseDir)[1])
      };
      results.push({
        "id": idCount,
        "name": file,
        "group": group,
        "meta": newMeta
      });
      idCount++;
    });
  });
});

fs.writeFileSync("../datasets.json", JSON.stringify(results, null, 2));