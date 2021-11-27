"""Data transformation."""

import datetime as dt

import pandas as pd

import themis.constants as consts
import themis.data.constants as data_consts


def execute(
    initial_date: dt.datetime = None,
    final_date: dt.datetime = None,
) -> pd.DataFrame:
    """This function executes all data transformation steps so that the data respects the input
    format of the SIDARTHE model. If both `initial_date` and `final_date` are passed as parameter
    data will be filtered to include only data between this interval; otherwise, all data will be
    used. At the end of its execution, the function will (1) return the transformed data as a
    pandas.DataFrame and (2) create two files: a CSV file with the transformed data, as well
    a TXT file with the data formatted as the SIDARTHE Matlab simulation expects. This way, all
    the user needs to do is to copy over the data in the TXT file to the Matlab simulations and
    replace the variables as is in the TXT file.

    :param initial_date: Consider events from this date and on.
    :type client: class:`datetime.datetime`
    :param initial_date: Consider events up until this date.
    :type client: class:`datetime.datetime`
    :return: DataFrame with transformed events, with data between initial_date and final_date
        (if passed as parameter).
    :rtype: pandas.DataFrame
    """

    dataframe = _load()
    dataframe = _date_column_as_datetime(dataframe)
    dataframe = _remove_invalid_dates(dataframe)
    dataframe = _order_by_date(dataframe)
    dataframe = _rename_columns(dataframe)
    dataframe = _add_sidarthe_positivi_column(dataframe)
    dataframe = _filter_by_date(dataframe, initial_date, final_date)
    _dataframe_to_csv(dataframe)
    _dataframe_to_sidarthe_matlab_input(dataframe)

    return dataframe


def _load() -> pd.DataFrame:
    dataframe = pd.read_csv(
        filepath_or_buffer=data_consts.DATASET_IN_PATH,
        usecols=data_consts.DATASET_COLUMNS_REQUIRED,
    )
    dataframe = dataframe.convert_dtypes()

    return dataframe


def _date_column_as_datetime(dataframe: pd.DataFrame) -> pd.DataFrame:
    dataframe[data_consts.COLUMN_DT_REFERENCIA] = pd.to_datetime(
        dataframe[data_consts.COLUMN_DT_REFERENCIA],
        format=consts.DATE_ISO_FORMAT,
    )
    dataframe = dataframe.convert_dtypes()

    return dataframe


def _remove_invalid_dates(dataframe: pd.DataFrame) -> pd.DataFrame:
    mask = (
        dataframe[data_consts.COLUMN_DT_REFERENCIA] >= consts.COVID_FIRST_CASE_ISO_DATE
    )
    dataframe = dataframe.loc[mask].reset_index(drop=True).convert_dtypes()

    return dataframe


def _order_by_date(dataframe: pd.DataFrame) -> pd.DataFrame:
    dataframe = dataframe.sort_values(by=data_consts.COLUMN_DT_REFERENCIA)

    return dataframe


def _rename_columns(dataframe: pd.DataFrame) -> pd.DataFrame:
    dataframe = dataframe.rename(columns=data_consts.DATASET_COLUMN_RENAME_MAP)

    return dataframe


def _add_sidarthe_positivi_column(dataframe: pd.DataFrame) -> pd.DataFrame:
    dataframe[consts.COLUMN_POSITIVI] = (
        dataframe[consts.COLUMN_ISOLAMENTO_DOMICILIARE]
        + dataframe[consts.COLUMN_RICOVERATI_SINTOMI]
        + dataframe[consts.COLUMN_TERAPIA_INTENSIVA]
    )

    return dataframe


def _filter_by_date(
    dataframe: pd.DataFrame,
    initial_date: dt.datetime,
    final_date: dt.datetime,
) -> pd.DataFrame:
    if not initial_date or not final_date:
        return dataframe

    mask = (dataframe[consts.COLUMN_DATE] >= initial_date) & (
        dataframe[consts.COLUMN_DATE] <= final_date
    )
    dataframe = dataframe.loc[mask]

    return dataframe


def _dataframe_to_csv(dataframe: pd.DataFrame) -> None:
    dataframe.to_csv(
        path_or_buf=data_consts.DATASET_OUT_PATH,
        index=False,
    )


def _dataframe_to_sidarthe_matlab_input(dataframe: pd.DataFrame):
    series_to_matlab_array = lambda series: "".join(str(series.to_list()).split(","))

    # pylint: disable=invalid-name
    CasiTotali = series_to_matlab_array(dataframe[consts.COLUMN_CASITOTALI])
    Deceduti = series_to_matlab_array(dataframe[consts.COLUMN_DECEDUTI])
    Guariti = series_to_matlab_array(dataframe[consts.COLUMN_GUARITI])
    Isolamento_domiciliare = series_to_matlab_array(
        dataframe[consts.COLUMN_ISOLAMENTO_DOMICILIARE]
    )
    Ricoverati_sintomi = series_to_matlab_array(
        dataframe[consts.COLUMN_RICOVERATI_SINTOMI]
    )
    Terapia_intensiva = series_to_matlab_array(
        dataframe[consts.COLUMN_TERAPIA_INTENSIVA]
    )
    Positivi = series_to_matlab_array(dataframe[consts.COLUMN_POSITIVI])

    output = (
        f"CasiTotali={CasiTotali}/popolazione;\n"
        f"Deceduti={Deceduti}/popolazione;\n"
        f"Guariti={Guariti}/popolazione;\n"
        f"Isolamento_domiciliare={Isolamento_domiciliare}/popolazione;\n"
        f"Ricoverati_sintomi={Ricoverati_sintomi}/popolazione;\n"
        f"Terapia_intensiva={Terapia_intensiva}/popolazione;\n"
        f"Positivi={Positivi}/popolazione;\n"
    )

    with open(consts.SIDARTHE_OUT_PATH, "w", encoding=consts.FILE_ENCODING) as file:
        file.write(output)
