# Use an official Node.js image that gives us access to OS tools
FROM node:22-bullseye-slim

# Set an environment variable to tell Puppeteer where to find Chrome
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Install all the necessary libraries that Chrome needs to run on Linux
RUN apt-get update \
  && apt-get install -y \
  wget \
  gnupg \
  # Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
  # Note: this installs the necessary libs to make the browser work with puppeteer.
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y \
  google-chrome-stable \
  fonts-ipafont-gothic \
  fonts-wqy-zenhei \
  fonts-thai-tlwg \
  fonts-kacst \
  fonts-freefont-ttf \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Set the working directory inside our server
WORKDIR /usr/src/app

# Copy our package files
COPY package*.json ./

# Install our project's dependencies
RUN npm install

# Copy the rest of our application's code
COPY . .

# Tell our app to listen for requests on the port Render provides
EXPOSE 3000

# The command to run our app
CMD [ "node", "index.js" ]