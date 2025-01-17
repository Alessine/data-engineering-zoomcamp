#!/usr/bin/env python
# coding: utf-8

import os
import argparse
import gzip
import shutil
from time import time
import pandas as pd
from sqlalchemy import create_engine

def main(params):
    """Description"""
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    zipped_file_name=params.zipped_file_name
    url = f"{params.url}/{zipped_file_name}"
    csv_name = "output.csv"

    # download the data and unzip
    os.system(f"wget {url}")
    with gzip.open(zipped_file_name, 'rb') as f_in:
        with open(csv_name, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)

    # set up the engine
    engine = create_engine(f"postgresql://{user}:{password}@{host}:{port}/{db}")

    # read in and clean the data
    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000, low_memory=False)
    df = next(df_iter)
    df["tpep_pickup_datetime"] = pd.to_datetime(df["tpep_pickup_datetime"])
    df["tpep_dropoff_datetime"] = pd.to_datetime(df["tpep_dropoff_datetime"])

    # just create the table
    df.head(n=0).to_sql(name=table_name, con=engine, if_exists="replace")

    # add in the data in chunks
    while True:
        t_start = time()
        df.to_sql(name=table_name, con=engine, if_exists="append")
        df = next(df_iter)
        df["tpep_pickup_datetime"] = pd.to_datetime(df["tpep_pickup_datetime"])
        df["tpep_dropoff_datetime"] = pd.to_datetime(df["tpep_dropoff_datetime"])
        t_end = time()
        print(f"inserted another chunk, took {t_end-t_start:.3f} seconds")


if __name__ == '__main__':
    # parse command line arguments
    parser = argparse.ArgumentParser(
                        description='Ingest CSV data to Postgres')

    # user, password, host, port, database name, table name, url of the csv
    parser.add_argument("--user", help="user name for postgres")
    parser.add_argument("--password", help="password for postgres")
    parser.add_argument("--host", help="host for postgres")
    parser.add_argument("--port", help="port for postgres")
    parser.add_argument("--db", help="database name for postgres")
    parser.add_argument("--table_name", help="name of the table where we will write the results to")
    parser.add_argument("--zipped_file_name", help="name of the zipped file")
    parser.add_argument("--url", help="url of the zipped file")

    args = parser.parse_args()
    main(args)
