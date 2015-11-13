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
o Platt "Probabilistic outputs for support vector machines and comparison to regularized likelihood methods"
o Niculescu-Mizil, Caruana "Predicting good probabilities with supervised learning"

