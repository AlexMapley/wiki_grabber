# Wiki Grabber
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

## Creating Volumes
Getting the volumes set up on mac was actually the most difficult part, https://julien-chen.medium.com/k8s-how-to-mount-local-directory-persistent-volume-to-kubernetes-pods-of-docker-desktop-for-mac-b72f3ca6b0dd is a helpful article on this.

```shell
% kubectl get pv,pvc    
NAME                            CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                        STORAGECLASS   REASON   AGE
persistentvolume/wiki-grabber   2Gi        RWX            Retain           Bound    default/wiki-grabber-claim   hostpath                3m30s

NAME                                       STATUS   VOLUME         CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/wiki-grabber-claim   Bound    wiki-grabber   2Gi        RWX            hostpath       3m30s
```
We first define a `pv` that will use a `hostpath` volume, and then setup a `pvc` which can be used by the cronjob to claim this volume.

## The Cronjob
The cronjob will then mount this volume via the pvc, and on each run grab a random wikipedia article and write it to that volume.

```
 % kubectl get all       
NAME                              READY   STATUS      RESTARTS   AGE
pod/wiki-grabber-27577551-79z7h   0/1     Completed   0          84s
pod/wiki-grabber-27577552-knrsz   0/1     Completed   0          24s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   6h26m

NAME                         SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/wiki-grabber   * * * * *   False     0        24s             95s

NAME                              COMPLETIONS   DURATION   AGE
job.batch/wiki-grabber-27577551   1/1           4s         84s
job.batch/wiki-grabber-27577552   1/1           5s         24s
```

## Taking a look at these downloaded pages
We additionally create a `stateful-set` to help take a look at these volumes:
```shell
% kubectl get all
NAME                              READY   STATUS      RESTARTS   AGE
pod/volume-inspector-0            1/1     Running     0          4m26s
pod/wiki-grabber-27577563-f9nkz   0/1     Completed   0          2m35s
pod/wiki-grabber-27577564-kt46s   0/1     Completed   0          95s
pod/wiki-grabber-27577565-z6xjx   0/1     Completed   0          35s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   6h39m

NAME                                READY   AGE
statefulset.apps/volume-inspector   1/1     4m26s

NAME                         SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/wiki-grabber   * * * * *   False     0        35s             14m

NAME                              COMPLETIONS   DURATION   AGE
job.batch/wiki-grabber-27577563   1/1           4s         2m35s
job.batch/wiki-grabber-27577564   1/1           4s         95s
job.batch/wiki-grabber-27577565   1/1           4s         35s
```

If you run the `tunnel.sh` script you should be able to see our files easily:
```shell
% bash tunnel.sh 
/ # ls
bin            etc            media          proc           sbin           tmp            wiki_pages
dev            home           mnt            root           srv            usr
entrypoint.sh  lib            opt            run            sys            var
/ # cd wiki_pages/
/wiki_pages # ls -l
total 352
-rw-r--r--    1 root     root        256852 Jun  8 02:17 Wed Jun  8 02:17:00 UTC 2022
-rw-r--r--    1 root     root        101805 Jun  8 02:18 Wed Jun  8 02:18:00 UTC 2022
```