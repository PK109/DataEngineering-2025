FROM python:3.9

RUN pip install pandas pyarrow sqlalchemy psycopg2

WORKDIR /app

COPY upload-data.py upload-data.py

ENTRYPOINT [ "python", "upload-data.py" ]