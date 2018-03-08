(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.util = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

function prettyFloat(n, floatingPoint = 5){
  let temp = Math.pow(10, floatingPoint)
  return Math.round( n * temp ) / temp;
}


function isInt(n){
  return Number(n) === n && n % 1 === 0;
}


function copy(o){
  return JSON.parse(JSON.stringify(o));
}

Array.prototype.contains = function(v, accessor) {
  accessor = accessor|| function(o){return o;};
  for(var i = 0; i < this.length; i++) {
    if(accessor(this[i]) === accessor(v)) return true;
  }
  return false;
};

Array.prototype.unique = function(accessor) {
  var arr = [];
  for(var i = 0; i < this.length; i++) {
    if(!arr.contains(this[i], accessor)) {
      arr.push(this[i]);
    }
  }
  return arr;
}

Array.prototype.sample = function(N){
  tempThis = this.slice();
  sampled = [];
  for (var i = 0; i < N; i++) {
    sampled.push(tempThis.splice([Math.floor(Math.random()*tempThis.length)],1)[0]);
  }
  return sampled;
}

Array.prototype.shuffle = function(){
  for (let i = this.length; i; i--) {
    let j = Math.floor(Math.random() * i);
    [this[i - 1], this[j]] = [this[j], this[i - 1]];
  }
  return this;
}
Array.prototype.clone = function(){
  return JSON.parse(JSON.stringify(this));
}

const FIELD_PRESET = ["TMAX", "TMIN", "PRCP", "AWND", "WDF5", "WSF5", "SNOW", "SNWD", "name"];
const NAMES = {
  "TMAX": "Max Temperature (F)",
  "TMIN": "Min Temperature (F)",
  "PRCP": "Precipitation (inches)",
  "AWND": "Wind Speed (mph)",
  "WDF5": "Wind Direction (degrees)",
  "WSF5": "Strongest Gust Speed (mph)",
  "SNOW": "Snowfall (inches)",
  "SNWD": "Snow Depth (inches)",
  "name": "State"
}
const STATES = {
  "AL" : "Alabama",
  "AK" : "Alaska",
  "AZ" : "Arizona",
  "AR" : "Arkansas",
  "CA" : "California",
  "CO" : "Colorado",
  "CT" : "Connecticut",
  "DE" : "Delaware",
  "FL" : "Florida",
  "GA" : "Georgia",
  "HI" : "Hawaii",
  "ID" : "Idaho",
  "IL" : "Illinois",
  "IN" : "Indiana",
  "IA" : "Iowa",
  "KS" : "Kansas",
  "KY" : "Kentucky",
  "LA" : "Louisiana",
  "ME" : "Maine",
  "MD" : "Maryland",
  "MA" : "Massachusetts",
  "MI" : "Michigan",
  "MN" : "Minnesota",
  "MS" : "Mississippi",
  "MO" : "Missouri",
  "MT" : "Montana",
  "NE" : "Nebraska",
  "NV" : "Nevada",
  "NH" : "New Hampshire",
  "NJ" : "New Jersey",
  "NM" : "New Mexico",
  "NY" : "New York",
  "NC" : "North Carolina",
  "ND" : "North Dakota",
  "OH" : "Ohio",
  "OK" : "Oklahoma",
  "OR" : "Oregon",
  "PA" : "Pennsylvania",
  "RI" : "Rhode Island",
  "SC" : "South Carolina",
  "SD" : "South Dakota",
  "TN" : "Tennessee",
  "TX" : "Texas",
  "UT" : "Utah",
  "VT" : "Vermont",
  "VA" : "Virginia",
  "WA" : "Washington",
  "WV" : "West Virginia",
  "WI" : "Wisconsin",
  "WY" : "Wyoming"
};
const MONTHS = {
  "01": "Jan.",
  "02": "Feb.",
  "03": "Mar.",
  "04": "Apr.",
  "05": "May",
  "06": "Jun.",
  "07": "Jul.",
  "08": "Aug.",
  "09": "Sep.",
  "10": "Oct.",
  "11": "Nov.",
  "12": "Dec."
};

function prettyRegionMonth(regionMonth){
  let [state, month] = [regionMonth.substring(0,2), regionMonth.substring(3,5)];
  // return `${STATES[state]} in ${MONTHS[month]}`;
  return `${STATES[state]}`;
}

function prettyField(field){
  return `<i>${NAMES[field]}</i>`.replace(/ \(.*\)/,'');
}

module.exports = {
  "prettyFloat": prettyFloat,
  "isInt" : isInt,
  "copy": copy,
  "prettyField": prettyField,
  "prettyRegionMonth": prettyRegionMonth,
  "MONTHS": MONTHS,
  "STATES": STATES,
  "NAMES": NAMES,
  "FIELD_PRESET": FIELD_PRESET
};
},{}]},{},[1])(1)
});