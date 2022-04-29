FROM docker.io/python:3.8.6-slim

WORKDIR /code

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py unique_code.py ./

EXPOSE 30001

CMD ["python", "app.py", "30001"]
