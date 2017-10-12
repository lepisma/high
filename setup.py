from setuptools import find_packages, setup

with open("README.org") as readme_file:
    readme = readme_file.read()

project_url = "https://github.com/lepisma/high"

setup(
    name="high",
    version="0.1.0",
    description="Hy utility belt",
    long_description=readme,
    author="Abhinav Tushar",
    author_email="abhinav.tushar.vs@gmail.com",
    url=project_url,
    install_requires=[
        "colorama",
        "hy==0.13.0",
        "matplotlib",
        "numpy"
    ],
    keywords="",
    packages=find_packages(),
    classifiers=(
        "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
        "Natural Language :: English",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3 :: Only"
    ))
