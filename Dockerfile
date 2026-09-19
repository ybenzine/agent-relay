FROM python:3.11-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy PYTHONUNBUFFERED=1

COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project

COPY *.py dashboard.html ./

# Set RELAY_DATABASE_URL to a PostgreSQL URL (see compose.yaml).
ENV PATH="/app/.venv/bin:$PATH"
RUN useradd --system --uid 1000 relay
USER relay

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
