FROM node:22-alpine
COPY . /app
WORKDIR /app
EXPOSE 8080
RUN apk add curl
RUN npm install express
RUN npm install --save-dev @types/express
RUN npm install ts-node typescript --save-dev
RUN npm install --save-dev ts-node
RUN npm init -y
RUN npx tsc --init
CMD ["npm", "start"]



