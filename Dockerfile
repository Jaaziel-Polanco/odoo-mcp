# Odoo MCP server -- HTTP mode (single-tenant).
#
# Build stage installs the package into a clean prefix so the runtime image
# carries no build tooling and no source tree. Skills ship inside the wheel as
# mcp_server_odoo/_skill_data (see pyproject force-include), so skill:// URIs
# resolve without the repo checkout being present.

FROM python:3.12-slim AS build

WORKDIR /src

COPY pyproject.toml README.md ./
COPY mcp_server_odoo ./mcp_server_odoo
COPY skills ./skills

RUN pip install --no-cache-dir --prefix=/install .


FROM python:3.12-slim

# Surfaced in the mcp_server_started event and server info. Set it in the
# platform's build args to trace which commit a running container came from.
ARG GIT_COMMIT=unknown
ENV GIT_COMMIT=${GIT_COMMIT}

COPY --from=build /install /usr/local

# HTTP transport bound to all interfaces -- the container is the boundary,
# not localhost. Put auth in front of it (see SETUP.md).
ENV ODOO_MCP_TRANSPORT=streamable-http \
    ODOO_MCP_HOST=0.0.0.0 \
    ODOO_MCP_PORT=8000 \
    PYTHONUNBUFFERED=1

RUN useradd --create-home --uid 10001 mcp
USER mcp
WORKDIR /home/mcp

EXPOSE 8000

# No HTTP health route exists -- GET /mcp without the MCP headers returns 406.
# A TCP connect is the honest liveness signal here.
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD python -c "import socket; socket.create_connection(('127.0.0.1', 8000), 3).close()"

CMD ["python", "-m", "mcp_server_odoo"]
