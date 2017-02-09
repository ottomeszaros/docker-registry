# Private Docker Registry

It enables you to run your own registry, and store your docker images locally. It is secured with simple http authentication and encrypted using TLS.

## htpasswd

Create your own users and passwords.

```
htpasswd -Bbn john 1234 > auth/htpasswd
```

## TLS

Generate self signed certificates.

```
make cert
```

## start server

```
make run
```

## list images

```
curl --user john:1234 --cacert ./certs/ca.pem  https://127.0.0.1:5000/v2/_catalog
```

## get docker-ls

```
https://github.com/mayflower/docker-ls/releases
```