
FROM node:21.6.1-bullseye

ARG WORKDIR

ENV HOME=/${WORKDIR}

WORKDIR ${HOME}

RUN apt update
COPY . ./
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

EXPOSE 5173
CMD ["npx", "vite", "dev", "--host"]