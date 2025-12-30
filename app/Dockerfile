FROM python:3.11-slim as BUILD

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt



FROM python:3.11-slim

RUN useradd --create-home --shell /usr/sbin/nologin appuser

WORKDIR /app

ENV TABLE_NAME=changeme

COPY --from=BUILD /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

COPY . .

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]