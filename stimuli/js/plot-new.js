function plot(elm, partialSpec, dataset, question, renderer = "svg"){
  return new Promise((resolve, reject)=>{

    let vl = util.copy(partialSpec);
    Object.keys(vl.encoding).forEach(ch=>{
      const vlField = vl.encoding[ch].field;
      let dataField =  "name";
      if (vlField === "Q1") {
        dataField = question.Q1;
      } else if (vlField === "Q2") {
        dataField = question.Q2;
      }

      vl.encoding[ch].field = dataField;
      if (["size", "color", "shape"].contains(ch)) {
        vl.encoding[ch].legend = {"title": util.NAMES[dataField]};
        if (["TMAX", "TMIN"].contains(dataField) && ch ==="size") {
          vl.encoding[ch].scale = { "zero": false };
        }
      } else if (["row", "column"].contains(ch)) {
        vl.encoding[ch].header = {"title": util.NAMES[dataField]};
      } else {
        vl.encoding[ch].axis = {"title": util.NAMES[dataField]};
        if (["TMAX", "TMIN"].contains(dataField)) {
          vl.encoding[ch].scale = { "zero": false };
        }
      }
      if (ch==="color" && dataField === "name") {
        if (question.cardinality <= 10) {
          vl.encoding[ch].scale = {"scheme": "tableau10"};
        } else {
          vl.encoding[ch].scale = {"scheme": "tableau20"};
        }

      }
    });
    let boundData = JSON.parse(JSON.stringify(dataset));
    boundData.forEach(d=> {
      d.name = util.prettyRegionMonth(d.name);
    });
    vl.data = {"values": boundData};

    vega.embed(elm, vl, {
      "actions": true,
      "renderer": renderer,
      "onBeforeParse": annotate
    }).then(result => {
      let view = result.view;
      resolve(result);
    }).catch(error => {
      reject(error);
    });
  });
}

function annotate(vg){
  let annotated = util.copy(vg);
  let givenData = vg.data[0].values;
  let annotatedA = givenData.filter(d=> d.annotated === 'A')[0];
  let annotatedB = givenData.filter(d=> d.annotated2 === 'B')[0];
  if (!annotatedA) {
    return vg;
  }
  annotatedA = util.copy(annotatedA);
  annotatedA.id = "";
  if (annotatedB) {
    annotatedB = util.copy(annotatedB);
    annotatedB.id = "2";
  }

  let marks, basicMark;
  if (annotated.marks.map(d=> d.name).indexOf("cell") < 0) {
    annotated.data.push({
      "name": "annotatedData",
      "source": "source_0",
      "transform": [
        {
          "type": "filter",
          "expr": "datum.annotated"
        }
      ]
    });
    annotated.data.push({
      "name": "annotatedData2",
      "source": "source_0",
      "transform": [
        {
          "type": "filter",
          "expr": "datum.annotated2"
        }
      ]
    });
    marks = annotated.marks;
    basicMark = annotated.marks[0];
  } else {
    cellMark = annotated.marks.filter(mark => mark.name ==="cell")[0];
    cellMark.data = [{
      "name": "annotatedData",
      "source": "facet",
      "transform":[{
        "type":"filter",
        "expr":"datum.annotated"
      }]
    }];
    cellMark.data.push({
      "name": "annotatedData2",
      "source": "facet",
      "transform":[{
        "type":"filter",
        "expr":"datum.annotated2"
      }]
    });
    marks = cellMark.marks;
    basicMark = cellMark.marks[0];
  }

  
  if (!!annotatedB) {
    let xField = basicMark.encode.update.x.field;
    let yField = basicMark.encode.update.y.field;
    let xRange = xField !== "name" ? getXYRange(xField, givenData) : undefined;
    let xNames = xField !== "name" ? undefined : givenData.map(d=> d.name).unique().sort();
    let yNames = yField !== "name" ? undefined : givenData.map(d=> d.name).unique().sort();
    let yRange = yField !== "name" ? getXYRange(yField, givenData) : undefined;
    if(xField !== "name" || xNames.indexOf(annotatedB[xField]) !== xNames.indexOf(annotatedA[xField]))  {
      let right = annotatedB;
      let left = annotatedA;
      if (
        (xNames && xNames.indexOf(annotatedB[xField]) < xNames.indexOf(annotatedA[xField])) ||
        (!xNames && (annotatedB[xField] < annotatedA[xField]))
      ) {
        right = annotatedA;
        left = annotatedB;
      }
      if (
        (xNames && xNames.indexOf(right[xField])===xNames.length-1) ||
        (!xNames && (xRange[1]-xRange[0])*0.8+xRange[0] < right[xField]) // If the right is too right.
      ) {
        if (
          (xNames && xNames.indexOf(left[xField])===0) ||
          (!xNames && left[xField] < (xRange[1]-xRange[0])*0.2+xRange[0]) // If the left is too left.
        ) {
          addAnnotation(Math.PI / 6, 20, left.id, 3);
          addAnnotation(Math.PI - Math.PI / 3, 14, right.id);
        } else {
          if (
            (!xNames && !yNames && ((left[xField] - right[xField]) / (xRange[1]-xRange[0]) / (left[yField] - right[yField]) * (yRange[1]-yRange[0]) > 1 )) ||
            (yNames && (yNames.indexOf(left.name) < yNames.indexOf(right.name)))
          ) {
            addAnnotation(Math.PI - Math.PI / 3, 14, left.id);
            addAnnotation(Math.PI - Math.PI / 6, 20, right.id, 3);
          } else {
            addAnnotation(Math.PI - Math.PI / 6, 20, left.id, 3);
            addAnnotation(Math.PI - Math.PI / 3, 14, right.id);
          }
        }
      } else {
        if (
            (!xNames && !yNames && ((right[xField] - left[xField]) / (xRange[1]-xRange[0]) / (right[yField] - left[yField]) * (yRange[1]-yRange[0]) > 1 )) ||
            (yNames && (yNames.indexOf(right.name) < yNames.indexOf(left.name)))
          ) {
          addAnnotation(Math.PI / 3, 14, right.id);
          addAnnotation(Math.PI / 6, 20, left.id, 3);
        } else {
          addAnnotation(Math.PI / 6, 20, right.id, 3);
          addAnnotation(Math.PI / 3, 14, left.id);
        }
      }

    } else {
      let top = annotatedB;
      let bottom = annotatedA;
      if (annotatedB[yField] < annotatedA[yField]) {
        top = annotatedA;
        bottom = annotatedB;
      }
      if (xNames.indexOf(top[xField])===xNames.length-1) {
        addAnnotation(Math.PI - Math.PI / 3, 14, top.id);
        addAnnotation(Math.PI - Math.PI / 6, 20, bottom.id, 3);
      } else {
        addAnnotation(Math.PI / 3, 14, top.id);
        addAnnotation(Math.PI / 6, 20, bottom.id, 3);
      }

    }
  } else {
    addAnnotation(Math.PI / 3, 14, "");
  }






  function  addAnnotation(angle, length, id, dy){

    let annotationLine = {
      "name": `annotation${id}-line`,
      "type": "rule",
      "role": "line",
      "from": {
        "data": `annotatedData${id}`
      },
      "encode": {
        "update" : {
          "x" : util.copy(basicMark.encode.update.x),
          "y" : util.copy(basicMark.encode.update.y),
          "x2" : util.copy(basicMark.encode.update.x),
          "y2" : util.copy(basicMark.encode.update.y),
          "stroke": {"value": "#000"}
        }
      }
    };

    if (basicMark.encode.update.size) {
      let xField = basicMark.encode.update.x.field;
      let yField = basicMark.encode.update.y.field;
      let sizeField = basicMark.encode.update.size.field;
      annotationLine.encode.update.x = { "signal": `scale('x', datum.${xField}) + sqrt(scale('size', datum.${sizeField}))/2*cos(${angle})` };
      annotationLine.encode.update.x2 = { "signal": `scale('x', datum.${xField}) + sqrt(scale('size', datum.${sizeField}))/2*cos(${angle})` };
      annotationLine.encode.update.y = { "signal": `scale('y', datum.${yField}) - sqrt(scale('size', datum.${sizeField}))/2*sin(${angle})` };
      annotationLine.encode.update.y2 = { "signal": `scale('y', datum.${yField}) - sqrt(scale('size', datum.${sizeField}))/2*sin(${angle})` };
      annotationLine.encode.update.x2.offset = {"signal": `(${length} - sqrt(scale('size', datum.${sizeField}))/2)* cos(${angle})`};
      annotationLine.encode.update.y2.offset = {"signal": `(-${length} + sqrt(scale('size', datum.${sizeField}))/2)* sin(${angle})`};
    } else {
      annotationLine.encode.update.x.offset = Math.sqrt(30) / 2 * Math.cos(angle);
      annotationLine.encode.update.y.offset = - Math.sqrt(30) / 2 * Math.sin(angle);
      annotationLine.encode.update.x2.offset = length * Math.cos(angle);
      annotationLine.encode.update.y2.offset = -length * Math.sin(angle);
    }

    marks.push(annotationLine);

    let annotationText = {
      "name": `annotation${id}-text`,
      "type": "text",
      "role": "text",
      "from": {
        "data": `annotatedData${id}`
      },
      "encode": {
        "update" : {
          "text":{"field": `annotated${id}`},
          "fontWeight": { "value": "bold" },
          "fontSize": { "value": 12 },
          "fill": {"value": "#000"},
          "stroke": {"value": "#fff"},
          "strokeWidth": {"value": 0.3},
          "x" : util.copy(annotationLine.encode.update.x2),
          "y" : util.copy(annotationLine.encode.update.y2),
        }
      }
    };
    if (!!dy) {
      annotationText.encode.update.dy = {"value": dy};
    }
    if (angle > Math.PI / 2 && angle < 3 * Math.PI / 2) {
      annotationText.encode.update.align = {"value": "right"};
    }
    marks.push(annotationText);
  }
  function getXYRange(field, data){
    let fieldData = data.map(d => d[field]);
    if (["TMIN", "TMAX"].indexOf(field) >= 0 ) {
      return [Math.min(...fieldData),Math.max(...fieldData)];
    } else {
      return [Math.min(0, Math.min(...fieldData)), Math.max(...fieldData)];
    }
  }

  return annotated;
}