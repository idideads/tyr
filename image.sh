#!/bin/bash
gcr_registry="k8s.gcr.io"                           #source_registry
ali_registry="registry.cn-hongkong.aliyuncs.com"    #target_registry
ali_namespace="tyr";

images=(
    kube-apiserver:v1.22.2
    kube-controller-manager:v1.22.2
    kube-scheduler:v1.22.2
    kube-proxy:v1.22.2
    pause:3.5
    etcd:3.5.0-0
    coredns/coredns:v1.8.4
)

for imageName in ${images[@]} ; do
    docker pull ${gcr_registry}/$imageName
    if [ $imageName = "coredns/coredns:v1.8.4" ]
    then
        docker tag ${gcr_registry}/$imageName ${ali_registry}/${ali_namespace}/coredns:v1.8.4
        docker push ${ali_registry}/${ali_namespace}/coredns:v1.8.4
    else
        docker tag ${gcr_registry}/$imageName ${ali_registry}/${ali_namespace}/${imageName}
        docker push ${ali_registry}/${ali_namespace}/${imageName}
    fi
done