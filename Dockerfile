FROM golang:1.14-alpine as claat

RUN apk add --no-cache \
    git && \
    go get github.com/googlecodelabs/tools/claat

FROM node:12.16-alpine
COPY --from=claat /go/bin/claat /usr/local/bin/

WORKDIR /workspace

COPY ./package.json ./package-lock.json /workspace/
RUN npm install

COPY . .
RUN claat export -o build_codelabs codelabs/*.md

ENV PATH ./node_modules/.bin/:$PATH

EXPOSE 8000

CMD ["gulp", "serve", "--codelabs-dir=build_codelabs"]