FROM node:22-alpine
COPY . /app
WORKDIR /app
EXPOSE 8080
RUN cd src
RUN curl -o- https://fnm.vercel.app/install | bash
RUN fnm install 22
RUN npm install express
RUN npm install --save-dev @types/express
RUN npm install ts-node typescript --save-dev
RUN npm install --save-dev ts-node
RUN npm init -y
RUN npx tsc --init
RUN npm start
CMD ["npm", "start"]



