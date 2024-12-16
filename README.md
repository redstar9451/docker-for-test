# create docker for coder

## How to build docker image

```shell
./build.sh
```

## How to deploy

kubectl apply -f k8s.yaml

## golang docker image, run on mac M2

```shell
docker build -t mytest -f dockerfile .
docker run -d --name go.arm -v <local path>:<remote path> mytest
docker run -it mytest bash
docker stop go.arm && docker rm go.arm

```
