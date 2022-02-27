FROM node:16-alpine

WORKDIR /node/app

COPY . .

RUN yarn && yarn run build

CMD ["nginx", "-g", "daemon off;"]

EXPOSE 3000
