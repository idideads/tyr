#!/bin/bash

#source_registry
gcr_registry="k8s.gcr.io"

#target_registry
# ali_region_id="cn-hongkong"
# ali_region_id="cn-shenzhen"
# ali_region_id="us-west-1"
ali_region_id="cn-guangzhou"
ali_registry="registry.${ali_region_id}.aliyuncs.com"
ali_namespace="tyr";

images=(
    # kubeadm config images list
    kube-apiserver:v1.22.2
    kube-controller-manager:v1.22.2
    kube-scheduler:v1.22.2
    kube-proxy:v1.22.2
    pause:3.5
    etcd:3.5.0-0
    # coredns/coredns:v1.8.4    # aliyun container registry does`t support second directory
    echoserver:1.4
)

for imageName in ${images[@]} ; do
    docker pull ${gcr_registry}/$imageName
    # if [ $imageName = "coredns/coredns:v1.8.4" ]
    # then
    #     docker tag ${gcr_registry}/$imageName ${ali_registry}/${ali_namespace}/coredns:v1.8.4
    #     docker push ${ali_registry}/${ali_namespace}/coredns:v1.8.4
    # else
    #     docker tag ${gcr_registry}/$imageName ${ali_registry}/${ali_namespace}/${imageName}
    #     docker push ${ali_registry}/${ali_namespace}/${imageName}
    # fi
    docker tag ${gcr_registry}/$imageName ${ali_registry}/${ali_namespace}/${imageName}
    docker push ${ali_registry}/${ali_namespace}/${imageName}
done

# aliyun container registry does`t support second directory,
# so here we just tag it to the first directory
docker pull ${gcr_registry}/coredns/coredns:v1.8.4
docker tag ${gcr_registry}/coredns/coredns:v1.8.4 ${ali_registry}/${ali_namespace}/coredns:v1.8.4
docker push ${ali_registry}/${ali_namespace}/coredns:v1.8.4
