"""Adapt SIDARTHE model to the Pernambuco (Brazil) scenario."""

import datetime as dt

import themis.data.transform


INITIAL_DATE = dt.datetime.fromisoformat("2020-04-03")
FINAL_DATE = dt.datetime.fromisoformat("2020-05-19")


def main():
    """Main program, achieves the following:

    - Data transformation.
    - Writes transformed data in CSV format to the data/out.
    - Writes transformed data in TXT format, as expected by the Matlab simulation, to the data/out.
    """
    _ = themis.data.transform.execute(INITIAL_DATE, FINAL_DATE)


if __name__ == "__main__":
    main()
