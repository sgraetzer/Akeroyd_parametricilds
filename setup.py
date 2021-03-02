import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="parametricilds",
    version="0.0.1",
    author="Michael Akeroyd, Simone Graetzer, Jennifer Firth, and Samuel Smith",
    author_email="s.n.graetzer@salford.ac.uk",
    description="Interaural-level difference calculation",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/sgraetzer/parametricilds/",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.6",
)