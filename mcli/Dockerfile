FROM docker.io/python:3.8.6-slim

WORKDIR /code

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY mcli.py .

CMD ["python", "mcli.py", "0.0.0.0", "30001"]
