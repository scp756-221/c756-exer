FROM docker.io/python:3.8.6-slim

WORKDIR /code

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY music_test.py .

CMD ["python", "music_test.py", "0.0.0.0", "30001"]
