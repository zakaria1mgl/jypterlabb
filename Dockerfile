# Use the official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to non-interactive to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install necessary packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    sudo \
    apt-transport-https \
    ca-certificates \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# Set the default working directory
WORKDIR /app

# Copy your application files to the container (if you have any)
# COPY . .

# Set the default command to run when the container starts
CMD ["bash"]
