# calibration-example

This repository hosts a small example for calibrating binary classifiers.
In particular, it shows how to use Matlab's implementation of Platt scaling to calibrate the outputs of an SVM.

### Running the example

Download (and unzip) the Matlab version of the USPS data set.  You can use the provided script:
```
    ./getUSPS.sh
```

In matlab, run the toplevel script:
```
    usps_example
```		

### References
- Platt "Probabilistic outputs for support vector machines and comparison to regularized likelihood methods," 1999.
- Zadrozny and Elkan "Transforming classifier scores into accurate multiclass probability estimates," 2002.
- Niculescu-Mizil and Caruana "Predicting good probabilities with supervised learning," 2005.
- Tight subplot Matlab [script](http://www.mathworks.com/matlabcentral/fileexchange/27991-tight-subplot)

