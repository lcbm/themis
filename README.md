# Themis

>"Titan goddess of divine law and order, instructed mankind in the primal laws of justice and morality, such as the rules of hospitality, good governance and conduct of assembly."

Since the beginning of the COVID-19 pandemic, Brazil has confirmed more than 22 million cases and 611 thousand deaths by the disease. The high rate of hospitalizations and the contamination speed have had a detrimental effect on the global health system - compelling challenges not only of a biomedical and epidemiological nature, but also social, economic and political. Epidemiological models are essential to highlight the importance of restrictive measures and their impacts on the evolution of the pandemic, thus serving as a basis for planning public policies and measures of social distancing that reduce the speed at which the disease spreads.

This project proposes and adaptation of an epidemiological to the Pernambuco (Brazil) scenario. The model that considers eight stages of the disease: susceptible (S), infected (I), diagnosed (D), ailing (A), recognized (R), threatened (T), healed (H) and extinct (E), collectively called [SIDARTHE](https://www.nature.com/articles/s41591-020-0883-7).

## Contents

- [Roadmap](#roadmap)
- [Project Structure](#project-structure)
- [Installation and Usage](#installation-and-usage)
  - [System Installation and Usage](#system-installation-and-usage)
  - [Docker Installation and Usage](#docker-installation-and-usage)
- [Contributing](#contributing)
- [LICENSE](#license)

## Roadmap

This is the official roadmap for Themis. It gives an overview of future works and ideas that may be implemented in the project. This roadmap is subject to change and features will be added as needed.

**[ ] 1.0**

Apply the SIDARTHE Covid-19 model, as is (including the dates), for the Pernambuco (Brazil) data.

**[ ] 1.1**

Implement parameter optimization for the Pernambuco scenario.

Currently, the model parameters **ARE NOT** optimized for the Pernambuco scenario. Actually, it still uses the parameters for the original data (Italy). Implement parameter optimization for the Pernambuco scenario means optimizing these values for the Pernambuco (Brazil) data.

To aid in this process, the following information is providaded: all model parameters are positive numbers and have been estimated using the real data from Italy, according to the [SIDARTHE paper](https://www.nature.com/articles/s41591-020-0883-7). The SIDARTHE Covid-19 model parameters have the following real meaning:

- `a` signifies the rate of infection as a result of contacting among a susceptible case and an infected case.
- `b` signifies the rate of infection as a result of contacting among a susceptible case and a diagnosed case.
- `c` signifies the rate of infection as a result of contacting among a susceptible case and an ailing case.
- `d` signifies the rate of infection as a result of contacting among a susceptible case and a recognized case.
- `e` signifies the detection probability rate of infected symptomless cases.
- `θ` signifies the detection probability rate of infected with symptoms cases.
- `z` signifies the rate of probability at which an infected case is not conscious of becoming infected.
- `h` signifies the rate of probability at which an infected case is conscious of becoming infected.
- `m` signifies the rate at which undetermined infected case develops life-menacing signs.
- `v` signifies the rate at which the determined infected case develops life-menacing signs.
- `τ` signifies the death rate (for infected cases with life-menacing signs).
- `g`, `k`, `x`, `r` and `σ` signify the rate of healing for the five phases of infected cases.

>_**Source**: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7293538/_

Furthermore, a list of measure taken by the government, with date and detailed description, can be found [here](http://www.pge.pe.gov.br/PGEPE_LegislacaoEstadualCovid19.aspx). This information is very important to decide when (which days) the model parameters must change.

**[ ] 1.2**

Repeat `1.1` and `1.2`, except for more recent data and predict the impact of future social distancing measures.

## Project Structure

Folders other than the ones mention here are used internally or by developers and may be ignored.

### `/matlab`

This folder contains all the Matlab SIDARTHE simulation files from both the original paper as well as the adapted by us.

## Installation and Usage

There are a few ways to use this project. You may proceed to either to the [System Installation and Usage Section](#system-installation-and-usage) or, if you rather use [Docker](https://www.docker.com), to the [Docker Installation and Usage section](#docker-installation-and-usage) section.

### System Installation and Usage

To install the **project's system installation pre-requisites**, please follow the instructions in the links below:

- [Python 3.9](https://www.python.org/downloads/)
- [pip](https://pip.pypa.io/en/stable/installing/)

Once you have all pre-requisites installed , you may proceed to either the [Using Makefile section](#using-makefile), to install via **Makefile**.

#### Using Makefile

To bootstrap the project with `Makefile`, change your current working directory to the project's root directory and run the `bootstrap` command:

```bash
# change current working directory
$ cd <path/to/themis>

# install project dependencies
$ make bootstrap
```

#### Usage

In order to run the application using the **development environment**, use the following command:

```bash
# run the main.py file.
$ make run
```

### Docker Installation and Usage

To install the **project's Docker installation pre-requisites**, please follow the instructions in the link below:

- [Docker](https://docs.docker.com/get-docker/) 19.03 or later

>_**Note**: if you're using a Linux system, please take a look at [Docker's post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/)!_

#### Building and running

Once you have all pre-requisites installed, change your current working directory to the project's root:

```bash
# change current working directory
$ cd <path/to/themis>
```

In order to build the **Docker image**, use the command below:

```bash
# build docker image from Dockerfile
$ docker build . --file Dockerfile --tag themis:dev
```

Finally, run the **Docker container** with the following command:

```bash
# start the container and clean up upon exit.
$ docker run --rm --volume `pwd`:/usr/src/app --tty --interactive themis:dev
```

>_**Note**: the `--volume` flag binds and mounts `pwd` (your current working directory) to the container's `/usr/src/app` directory. This means that the changes you make outside the container will be reflected inside (and vice-versa). You may use your IDE to make code modifications, additions, deletions and so on, and these changes will be persisted both in and outside the container._

## Contributing

We are always looking for contributors of **all skill levels**! If you're looking to ease your way into the project, try out a [good first issue](https://github.com/lcbm/themis/labels/good%20first%20issue).

If you are interested in helping contribute to the project, please take a look at our [Contributing Guide](CONTRIBUTING.md). Also, feel free to drop in our [community chat](https://gitter.im/lcbm/community) and say hi. 👋

Also, thank you to all the [people who already contributed](https://github.com/lcbm/themis/graphs/contributors) to the project!

## License

Copyright © 2021-present, [Themis Contributors](https://github.com/lcbm/themis/graphs/contributors).

This project is [ISC](LICENSE) licensed.
