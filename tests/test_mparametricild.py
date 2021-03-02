import scipy.io
import os
import numpy.testing as npt
import pytest

import parametricilds
import tests.utils as utils

# Test that python mparametricild code reproduces MATLAB outputs.
# MATLAB inputs and outputs stored in mat files in data

RTOL = 1e-09  # error tolerance for allclose check
ATOL = 1e-09  # error tolerance for allclose check


@pytest.mark.parametrize(
    "filename",
    [
        "mparametricild-00df49db8935",
        "mparametricild-0a04d06b0a0d",
        "mparametricild-0a40c425f9d4",
        "mparametricild-0a29897d86e7",
        "mparametricild-0aab2339558c",
        "mparametricild-0b5a9339d246",
        "mparametricild-0b89126fd4c6",
        "mparametricild-0bd49e590d7c",
        "mparametricild-0c81b2561595",
        "mparametricild-0d20cc48f1ac",
        "mparametricild-0e5e86e33f4e",
        "mparametricild-0e28b1f110fd",
        "mparametricild-0ea51bc8e0c3",
        "mparametricild-0eaf75955bf5",
        "mparametricild-0edba6f4ab3e",
    ],
)
def test_mparametricild(filename, regtest):
    filename = os.path.dirname(os.path.abspath(__file__)) + "/data/" + filename
    data = scipy.io.loadmat(filename, squeeze_me=True)

    ild_db = parametricilds.mparametricild(data["freq_hz"], data["azimuth_degs"])
    npt.assert_allclose(ild_db, data["ild_db"], atol=ATOL, rtol=RTOL)
    # print(utils.hash_numpy(ild_db), file=regtest)
