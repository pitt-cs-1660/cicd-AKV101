FROM python:3.11-buster AS builder
WORKDIR /app
Run pip install --upgrade pip && pip install poetry
COPY pyproject.toml poetry.lock /app/
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi  

FROM python:3.11-buster
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 8000
ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
