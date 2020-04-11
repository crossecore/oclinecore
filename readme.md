# OCLinEcore ANTLR grammar

https://wiki.eclipse.org/OCL/OCLinEcore
https://help.eclipse.org/kepler/index.jsp?topic=%2Forg.eclipse.ocl.doc%2Fhelp%2FOCLinEcore.html

* Download ANTLR tooling from http://www.antlr.org/download/antlr-4.7.1-complete.jar

# JavaScript target

```bash
java -jar antlr-4.7.1-complete.jar -Dlanguage=JavaScript oclinecore.g4
```


Create index.js
```javascript
TBD
```

Create webpack.config
```javascript
{ module: "empty", net: "empty", fs: "empty" }
```


Install antlr4 runtime via NPM
```bash
npm install antlr4
```
Package with webpack
https://github.com/antlr/antlr4/blob/master/doc/javascript-target.md

```bash
webpack
```