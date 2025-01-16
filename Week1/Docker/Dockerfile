FROM python:3.9

RUN pip install pandas pyarrow sqlalchemy psycopg2

WORKDIR /app

COPY upload-zones.py upload-zones.py

ENTRYPOINT [ "python", "upload-zones.py" ]