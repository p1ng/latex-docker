FROM debian:trixie-slim

# Prevent interactive installation prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install the complete TeX Live distribution
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        texlive-full \
    && rm -rf /var/lib/apt/lists/*

# Directory containing our LaTeX documents
WORKDIR /work

# Default to an interactive shell
CMD ["/bin/bash"]

