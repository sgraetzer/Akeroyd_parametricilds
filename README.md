# parametricilds

## Description and copyright information

Software for calculation of Interaural Level Differences (ILDs) in the horizontal plane via a set of parametric equations derived by fitting equations to the "self-consistent" smooth curves tabulated by Shaw and Vaillancourt (1985).

Matlab code written by Michael A. Akeroyd, Hearing Sciences, Division of Clinical Neurosciences, School of Medicine, University of Nottingham, Nottingham, NG7 2RD, U.K. (Feb. 2020, updated Feb. 2021)

Python translation: Simone Graetzer, Acoustics Research Centre, School of Science, Engineering and Environment, University of Salford, Salford, M5 4WT, UK (September 2020, updated Feb. 2021)

If you use this code in publications, please cite it as follows:

```
Akeroyd, M. A., Firth, J., Graetzer, S., Smith, S., A set of equations for numerically calculating the interaural level difference in the horizontal plane, J. Acoust. Soc. Am. Express Lett. 1(4), 044402, https://doi.org/10.1121/10.0004261

```


### Reference

Shaw, E.A.G. and Vaillancourt, M.M. (1985) “Transformation of sound‐pressure level from the free field to the eardrum presented in numerical form”, J. Acoust. Soc Am. 78:1120-1123. 

## Installation

```bash
git clone https://github.com/sgraetzer/Akeroyd_parametricilds
cd Akeroyd_parametricilds
# Set up python virtual environment
python -m venv env
source env/bin/activate
pip install --upgrade pip
pip install -r requirements-dev.txt
```

## Tests

To run tests:

```bash
coverage run -m py.test tests
coverage report -m
```

## Documentation

To build documentation using pdoc:

```bash
cd doc
./build.sh
```

(Note, pdoc3 and pdoc are the same)
