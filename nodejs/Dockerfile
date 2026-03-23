# Get base image
FROM node:22.17

# Install software
RUN apt-get update && apt-get install -y nano git curl

# Install pm2
RUN npm install pm2@latest -g

# Make pm2 directory
RUN mkdir -p /app
RUN mkdir -p /home/pm2

# Setting working directory
WORKDIR /app

# Set default user
USER root

# Keep the dev container running until a process is started manually
CMD [ "tail", "-f", "/dev/null" ]