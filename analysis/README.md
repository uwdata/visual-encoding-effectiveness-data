## How to Run Bootstrap Analysis


1. The code requires importing two external libraries.

```
npm install d3
npm install csvtojson
```

2. After installing them, run "node.js" application with `bootstrapCI.js` and three parameters:

```
node bootstrapCI.js (the path of the responses) (prefix of outputs) (# of iterations)

```

For example,
```
node bootstrapCI.js ../responses/responses.csv bootstrap_result 1000
```


3. The Output is `.json` files of arrays of objects.

- spec      : Bootstrap result involving all responses.
- spec_task : Bootstrap result per task
- spec_taskCategory : Bootstrap result per taskCategory (Value Tasks, Summary Tasks(Aggregate Tasks))
- spec_taskCategory_nPerCategory : Bootstrap result per (taskCategory, # / Category)
- spec_taskCategory_cardinality  : Bootstrap result per (taskCategory, Cardinality)
- spec_taskCategory_Q1Entropy    : Bootstrap result per (taskCategory, Q1 Entropy)
- spec_taskCategory_Q2Entropy    : Bootstrap result per (taskCategory, Q2 Entropy)

4. "bootstrap_result" folder includes the result we used in our paper.
