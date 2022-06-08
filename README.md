# wiki_grabber
k8s cronjob to download random wikipedia articles.

Every night at midnight, this program will download a random wikipedia page and store it to a persistent disk.

## Grabbing a random wikipedia page
You can grab the full html from a random wiki page with the following curl:
```shell
curl -L https://en.wikipedia.org/api/rest_v1/page/random/html
```

An example of that output was written to `example.html`, which you can open in a browser for a rough view. The example article there details **Wicklewood**, a town in Norfolk England.

## Running k8s on Docker Desktop
https://www.docker.com/blog/how-kubernetes-works-under-the-hood-with-docker-desktop/ is a great article with some primer info on docker desktop k8s.

You can enable kubernetes through the docker app, and see the context created and managed for you:
```shell
% kubectx
docker-desktop

% kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://kubernetes.docker.internal:6443
  name: docker-desktop
contexts:
- context:
    cluster: docker-desktop
    user: docker-desktop
  name: docker-desktop
current-context: docker-desktop
kind: Config
preferences: {}
users:
- name: docker-desktop
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED

% kubens
default
kube-node-lease
kube-public
kube-system
```