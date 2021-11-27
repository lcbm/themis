"""Identifiers used across modules."""

# OTHERS
FILE_ENCODING = "UTF-8"

# DATA HANDLING CONSTANTS
DATE_ISO_FORMAT = "%Y-%m-%d"

# COVID-19 CONSTANTS
COVID_FIRST_CASE_ISO_DATE = "2020-02-26"

# DATASET CONSTANTS
__DATASET_DIR = "data"
DATASET_IN_DIR = f"{__DATASET_DIR}/in"
DATASET_OUT_DIR = f"{__DATASET_DIR}/out"

GET_DATASET_PATH = lambda dir, name, ext: f"{dir}/{name}.{ext}"

COLUMN_DATE = "Date"

# SIDARTHE CONSTANTS
SIDARTHE_NAME = "sidarthe"
SIDARTHE_EXT = "txt"
SIDARTHE_OUT_PATH = GET_DATASET_PATH(DATASET_OUT_DIR, SIDARTHE_NAME, SIDARTHE_EXT)

# D+R+T+E+H_diagnosticati
COLUMN_CASITOTALI = "CasiTotali"
# E: Deaths
COLUMN_DECEDUTI = "Deceduti"
# Recovered: H_diagnosticati
COLUMN_GUARITI = "Guariti"
# D: Currently positive and isolated at home
COLUMN_ISOLAMENTO_DOMICILIARE = "Isolamento_domiciliare"
# R: Currently positive and hospitalized
COLUMN_RICOVERATI_SINTOMI = "Ricoverati_sintomi"
# T: Currently positive and in ICU
COLUMN_TERAPIA_INTENSIVA = "Terapia_intensiva"
# D+R+T: Currently Positive
COLUMN_POSITIVI = "Positivi"

SIDARTHE_COLUMNS = [
    COLUMN_CASITOTALI,
    COLUMN_DECEDUTI,
    COLUMN_GUARITI,
    COLUMN_ISOLAMENTO_DOMICILIARE,
    COLUMN_RICOVERATI_SINTOMI,
    COLUMN_TERAPIA_INTENSIVA,
    COLUMN_POSITIVI,
]
