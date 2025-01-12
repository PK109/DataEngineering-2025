#!/usr/bin/env python

import pandas as pd
from sqlalchemy import create_engine
from time import time
import os
import argparse

def main(params):

    user = params.user
    password = params.password
    host = params.host
    port = params.port
    database_name = params.database_name
    table_name = params.table_name
    file_url = params.file_url
    output_file = 'output_file.parquet'

    os.system(f'wget {file_url} -O {output_file}')

    df = pd.read_parquet(f'{output_file}')

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{database_name}')
    engine.connect()

    header = df.head(0)
    header.to_sql(name= table_name, con=engine, if_exists='replace')

    iterator = 0
    ix_start = 0
    ix_end = 0
    while ix_end < len(df):
        t_start = time()
        ix_start = iterator * 100000
        ix_end = (iterator +1) * 100000
        df[ix_start:ix_end].to_sql(name= table_name, con=engine, if_exists='append')
        t_end = time()
        print(f'Ingested values between indexes {ix_start} and {ix_end}. It tooks {round(t_end - t_start)} seconds.')
        iterator += 1
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
                            description='Ingest parquet data to Postgres',
                            epilog='Text at the bottom of help')

    parser.add_argument('--user')           # positional argument
    parser.add_argument('--password')           # positional argument
    parser.add_argument('--host')           # positional argument
    parser.add_argument('--port')           # positional argument
    parser.add_argument('--database_name')           # positional argument
    parser.add_argument('--table_name')           # positional argument
    parser.add_argument('--file_url')           # positional argument

    args = parser.parse_args()

    main(args)