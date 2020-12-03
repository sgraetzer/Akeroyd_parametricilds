import numpy as np
import math
from scipy.stats import norm


def mparametricild(freq_hz, azimuth_degs):
    """
    Translation of Michael Akeroyd (MAA) and colleagues' MATLAB code for computing
    interaural level differences based on frequency and azimuth in degrees.
    MATLAB copyright MAA Feb 2020

    Args:
        freq_hz (float): frequency in Hz
        azimuth_degs (int): azimuth in degrees

    Returns:
        ILD: interaural level difference

    """
    f_logkhz = np.log10(freq_hz / 1000)
    a_rads = azimuth_degs / 360 * 2 * math.pi

    # parameters pasted from excel 20200402a
    mainparameters = np.zeros((5, 14))
    mainparameters[0, :] = [
        13.0621,
        11.6956,
        -4.0224,
        0.6882,
        0.2223,
        2.8651,
        0.2034,
        0.3508,
        -1.7716,
        0.3034,
        0.1137,
        0.6188,
        0.7882,
        0.0489,
    ]
    mainparameters[1, :] = [
        -0.5782,
        0.5041,
        -0.9590,
        -0.6493,
        0.3741,
        -0.1439,
        0.0345,
        0.1678,
        -0.0443,
        0.2955,
        0.0678,
        0.0389,
        0.6539,
        0.0640,
    ]
    mainparameters[2, :] = [
        0.6466,
        1.1185,
        -9.0378,
        1.3305,
        0.2196,
        -7.5159,
        0.0522,
        0.3522,
        1.2418,
        0.2660,
        0.1070,
        -0.1280,
        0.5030,
        0.0300,
    ]
    mainparameters[3, :] = [
        -0.2238,
        1.6047,
        -6.0000,
        1.3402,
        0.0300,
        2.8675,
        -1.0099,
        0.1350,
        -0.0405,
        0.8272,
        0.0300,
        -0.0282,
        0.4746,
        0.0539,
    ]
    mainparameters[4, :] = [
        -0.0629,
        0.3258,
        -0.1153,
        0.7487,
        0.1261,
        -0.0551,
        0.2448,
        0.0919,
        0.0398,
        -0.3022,
        0.1494,
        0.1600,
        0.6487,
        0.5839,
    ]

    fivekhzpertubationparameters = np.array([-0.2664, 0.7067, 0.0763, 2.7500, 0.2000])

    # extract
    row = 0
    primarymagnitude_line_slope = mainparameters[row, 0]
    primarymagnitude_line_constant = mainparameters[row, 1]
    primarymagnitude_normal = np.zeros((4, 3))
    for n in range(4):
        primarymagnitude_normal[n, 0] = mainparameters[row, (n + 1) * 3 - 1]  # mag
        primarymagnitude_normal[n, 1] = mainparameters[row, (n + 1) * 3 + 0]  # mu
        primarymagnitude_normal[n, 2] = mainparameters[row, (n + 1) * 3 + 1]  # std

    row = 1
    asymmetry_line_slope = mainparameters[row, 0]
    asymmetry_line_constant = mainparameters[row, 1]
    asymmetry_normal = np.zeros((4, 3))
    for n in range(4):
        asymmetry_normal[n, 0] = mainparameters[row, (n + 1) * 3 - 1]  # mag
        asymmetry_normal[n, 1] = mainparameters[row, (n + 1) * 3 + 0]  # mu
        asymmetry_normal[n, 2] = mainparameters[row, (n + 1) * 3 + 1]  # std

    row = 2
    dipmagnitude_line_slope = mainparameters[row, 0]
    dipmagnitude_line_constant = mainparameters[row, 1]
    dipmagnitude_normal = np.zeros((4, 3))
    for n in range(4):
        dipmagnitude_normal[n, 0] = mainparameters[row, (n + 1) * 3 - 1]  # mag
        dipmagnitude_normal[n, 1] = mainparameters[row, (n + 1) * 3 + 0]  # mu
        dipmagnitude_normal[n, 2] = mainparameters[row, (n + 1) * 3 + 1]  # std

    row = 3
    dipmu_line_slope = mainparameters[row, 0]
    dipmu_line_constant = mainparameters[row, 1]
    dipmu_normal = np.zeros((4, 3))
    for n in range(4):
        dipmu_normal[n, 0] = mainparameters[row, (n + 1) * 3 - 1]  # mag
        dipmu_normal[n, 1] = mainparameters[row, (n + 1) * 3 + 0]  # mu
        dipmu_normal[n, 2] = mainparameters[row, (n + 1) * 3 + 1]  # std

    row = 4
    dipstd_line_slope = mainparameters[row, 0]
    dipstd_line_constant = mainparameters[row, 1]
    dipstd_normal = np.zeros((4, 3))
    for n in range(4):
        dipstd_normal[n, 0] = mainparameters[row, (n + 1) * 3 - 1]  # mag
        dipstd_normal[n, 1] = mainparameters[row, (n + 1) * 3 + 0]  # mu
        dipstd_normal[n, 2] = mainparameters[row, (n + 1) * 3 + 1]  # std

    fivekhzperturb_magnitude = np.zeros((4, 1))
    fivekhzperturb_magnitude[0] = fivekhzpertubationparameters[0]  # mag
    fivekhzperturb_magnitude[1] = fivekhzpertubationparameters[1]  # mu
    fivekhzperturb_magnitude[2] = fivekhzpertubationparameters[2]  # std
    fivekhzperturb_mu = fivekhzpertubationparameters[3]
    fivekhzperturb_std = fivekhzpertubationparameters[4]

    # Get the parameters for this frequency

    linearcontribution = (
        primarymagnitude_line_slope * f_logkhz + primarymagnitude_line_constant
    )
    normalcontribution = np.zeros((4, 1))
    for n in range(4):
        normalcontribution[n] = primarymagnitude_normal[n, 0] * norm.pdf(
            f_logkhz, primarymagnitude_normal[n, 1], primarymagnitude_normal[n, 2]
        )

    primarymagnitude = linearcontribution + np.sum(normalcontribution)

    linearcontribution = asymmetry_line_slope * f_logkhz + asymmetry_line_constant
    for n in range(4):
        normalcontribution[n] = asymmetry_normal[n, 0] * norm.pdf(
            f_logkhz, asymmetry_normal[n, 1], asymmetry_normal[n, 2]
        )

    asymmetryparameter = linearcontribution + np.sum(normalcontribution)

    linearcontribution = dipmagnitude_line_slope * f_logkhz + dipmagnitude_line_constant
    for n in range(4):
        normalcontribution[n] = dipmagnitude_normal[n, 0] * norm.pdf(
            f_logkhz, dipmagnitude_normal[n, 1], dipmagnitude_normal[n, 2]
        )

    dipmagnitude = linearcontribution + np.sum(normalcontribution)

    linearcontribution = dipmu_line_slope * f_logkhz + dipmu_line_constant
    for n in range(4):
        normalcontribution[n] = dipmu_normal[n, 0] * norm.pdf(
            f_logkhz, dipmu_normal[n, 1], dipmu_normal[n, 2]
        )

    dipmu = linearcontribution + np.sum(normalcontribution)

    linearcontribution = dipstd_line_slope * f_logkhz + dipstd_line_constant
    for n in range(4):
        normalcontribution[n] = dipstd_normal[n, 0] * norm.pdf(
            f_logkhz, dipstd_normal[n, 1], dipstd_normal[n, 2]
        )
    dipstd = linearcontribution + np.sum(normalcontribution)

    linearcontribution = 0
    normalcontribution = fivekhzperturb_magnitude[0] * norm.pdf(
        f_logkhz, fivekhzperturb_magnitude[1], fivekhzperturb_magnitude[2]
    )
    fivekhzmagnitude = linearcontribution + normalcontribution

    # Store for output
    parameters_primarymagnitude = primarymagnitude
    parameters_asymmetry = asymmetryparameter
    parameters_dipmagnitude = dipmagnitude
    parameters_dipmu = dipmu
    parameters_dipstd = dipstd
    parameters_fivekhzmagnitude = fivekhzmagnitude

    # .. and then use them to get the ILD ...
    primarysinusoid = primarymagnitude * np.sin(a_rads)
    asymmetry = asymmetryparameter * np.sin(2 * a_rads) + 1
    dip = dipmagnitude * norm.pdf(a_rads, dipmu, dipstd)
    fivekhz = fivekhzmagnitude * norm.pdf(a_rads, fivekhzperturb_mu, fivekhzperturb_std)

    ild_db = float(primarysinusoid * asymmetry + dip + fivekhz)
    print(f"ILD = {ild_db}")

    return ild_db


# if __name__ == "__main__":
#     freq_hz = np.array(
#         [
#             150,
#             188.98815748,
#             238.1101578,
#             300,
#             377.97631497,
#             476.22031559,
#             600,
#             755.95262994,
#             952.44063118,
#             1200,
#             1511.90525987,
#             1904.88126236,
#             2400,
#             3023.81051975,
#             3809.76252472,
#         ]
#     )
#     azimuth_degs = -46.75

#     ild_vals = []
#     for i, freq in enumerate(freq_hz):
#         ild_db = mparametricild(freq_hz[i], azimuth_degs)
#         ild_vals.append(ild_db)
#     print(ild_vals)
