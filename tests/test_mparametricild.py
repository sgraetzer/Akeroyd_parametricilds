import scipy.io
import os
import numpy.testing as npt
import pytest

import parametricilds
import tests.utils as utils

# Test that python mparametricild code reproduces MATLAB outputs.
# MATLAB inputs and outputs stored in mat files in data

RTOL = 1e-05  # error tolerance for allclose check
ATOL = 2e-05  # error tolerance for allclose check


@pytest.mark.parametrize(
    "filename",
    [
        "mparametricild-4b78a18a54ed.mat",
        "mparametricild-9a193b8503bf.mat",
        "mparametricild-863f4362da57.mat",
        "mparametricild-154041fa2adb.mat",
        "mparametricild-fbcf2712fde9.mat",
        "mparametricild-1b43148541b2.mat",
        "mparametricild-a91ba29514d3.mat",
        "mparametricild-7d467e1eef26.mat",
        "mparametricild-29ec3299dffb.mat",
        "mparametricild-fd50596acdff.mat",
    ],
)
def test_mparametricild(filename, regtest):
    filename = os.path.dirname(os.path.abspath(__file__)) + "/data/" + filename
    data = scipy.io.loadmat(filename, squeeze_me=True)

    ild_db = parametricilds.mparametricild(data["freq_hz"], data["azimuth_degs"])
    npt.assert_allclose(ild_db, data["ild_db"], atol=ATOL, rtol=RTOL)
    # print(utils.hash_numpy(ild_db), file=regtest)
