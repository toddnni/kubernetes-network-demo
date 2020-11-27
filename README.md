Intro
=====

This is vagrant demo to test out Kubernetes ingress and egress network security.

The Vagrant scripts setup has been copied from Rancher Quickstart <https://github.com/rancher/quickstart/tree/master/vagrant>. 
There is no License for them.


Cluster Startup
---------------

The startup can be flaky. If you have low resources, start first the rancher server

    vagrant up server-01

IP of the Rancher UI is visible in

    vagrant ssh-config server-01

Disable fleet feature in the UI (under Settings.FeatureFlags) to make rancher server more reliable.
And restart the rancher server 

    vagrant halt server-01; vagrant up server-01

Start the nodes

    vagrant up

Copy kubeconfig file of quickstart cluster from the Rancher UI to ~/.kube/config on server-01. *Special: ensure that server ip is 172.22.101.101*

Cluster topology is the following

    +-----------+
    | server-01 |
    |  Rancher  |
    +-----------+


    quickstart - RKE cluster
    +-----------+  +-----------+
    | node-01   |  | node-02   |
    |           |  |           |
    |           |  |           |
    |           |  |           |
    +-----------+  +-----------+
    master+worker     worker

Demos
------

The following simple demos show how Ingress and Egress works. 

There is no service nodePort example.

The examples need to be run on server-01

    vagrant ssh server-01
    cd /vagrant
    # demo setup need to be initialized once
    sh demo-setup/setup.sh
  
Demo 1 - Ingress
----------------

Run the scrips inside `demo1/`

See how the responds.

    +-----------+
    | server-01 |
    |  Rancher  |
    +-----------+
          |
       get HOST hello.example.com
          v
    +-----------+  +-----------+
    | node-01   |  | node-02   |
    |           |  |           |
    |echoserver |  |echoserver |
    |           |  |           |
    +-----------+  +-----------+

Demo 2 - Default Egress
----------------

See the scrips inside `demo2/`.

Notice how the requests come from the VM IP range `172.22.101.*` and from the different addresses.

    +-----------+
    | server-01 |
    |  Rancher  |
    +-----------+
          ^  ^
          |  +---------+
          |            |
    +-----------+  +-----------+
    | node-01   |  | node-02   |
    |           |  |           |
    |  shell1   |  |  shell2   |
    | (zone=A)  |  | (zone=B)  |
    +-----------+  +-----------+


Demo 3 - Network policies
----------------

See the scrips inside `demo3/`.


    +-----------+
    | server-01 |
    |  Rancher  |
    +-----------+
             ^
             +---------+
                       |
    +-----------+  +-----------+
    | node-01   |  | node-02   |
    |           |  |           |
    |echoserver<----  shell2   |
    |   (ns1)   |  |   (ns2)   |
    +-----------+  +-----------+

1. We are not able to limit the ingress traffic when the pods are using the host networking
2. We can block the traffic egress traffic to only specific destinations
3. We can block and allow traffic to apps with high granularity

Note. That the rules are per namespace.

Istio Service Mesh
-----------------

Istio adds whole new Istio Ingress and Istio Egress functionalities that can be used instead or alongside to the standard features.
