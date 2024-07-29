# Use a Python base image
FROM python:3.9-slim

# Install required packages
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and setuptools
RUN pip install --upgrade pip setuptools

# Install JupyterLab
RUN pip install jupyterlab

# Set the working directory
WORKDIR /app

# Expose port 8080
EXPOSE 8080

# Start JupyterLab on port 8080 without authentication
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8080", "--no-browser", "--allow-root", "--NotebookApp.token=''"]

