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

    df = pd.read_csv(f'{output_file}')

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{database_name}')
    engine.connect()

    df.to_sql(name= table_name, con=engine, if_exists='replace')    
    print(f"Taxi zones loaded into {table_name} table.")
    
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