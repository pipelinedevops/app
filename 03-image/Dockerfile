FROM node:18-alpine
COPY . /app
WORKDIR /app
EXPOSE 8080
RUN mkdir hello-world
RUN cd hello-world
RUN npm run start
CMD ["npm", "start"]

