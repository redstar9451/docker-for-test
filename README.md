# create docker for coder

## How to build docker image

```shell
# build golang 1.19 development
docker build --build-arg GO_VERSION=1.19 -t golang-dev:1.19 -f dockerfile .

# build golang 1.17 development
docker build --build-arg GO_VERSION=1.17 -t golang-dev:1.17 -f dockerfile .
```

## How to deploy

kubectl apply -f k8s.yaml

## docker run

```shell
docker build -t mytest -f dockerfile .
docker run -d --name go.arm -v <local path>:<remote path> mytest
docker run -it mytest bash
docker stop go.arm && docker rm go.arm
```
