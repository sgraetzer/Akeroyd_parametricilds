# parametricilds
Software for calculation of Interaural Level Differences (ILDs) in the horizontal plane via a set of parametric equations derived by fitting equations to the "self-consistent" smooth curves tabulated by Shaw and Vaillancourt (1985).

Matlab code written by Michael A. Akeroyd, Hearing Sciences, Division of Clinical Neurosciences, School of Medicine, University of Nottingham, Nottingham, NG7 2RD, U.K.

Python translation: Simone Graetzer, Acoustics Research Centre, School of Science, Engineering and Environment, University of Salford, Salford, M5 4WT, UK

## Installation

```bash
git clone https://github.com/sgraetzer/parametricilds
cd parametricilds
# Setup python virtual environment
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
