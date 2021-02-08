FROM node:alpine as builder
WORKDIR /frontend
COPY ./package.json ./yarn.lock ./
RUN yarn
COPY . .
RUN yarn build

# Run
FROM node:alpine
WORKDIR /frontend
COPY --from=builder /frontend/ ./
EXPOSE 3000
ENV HOST=0.0.0.0
CMD ["yarn", "start"]
