┌────────────────────────────────────────────────────────────────────────────────────────┐
│ CONTROL PLANE / MASTER NODE (The Brains)                                               │
│                                                                                        │
│   ┌───────────────────────┐       ┌───────────────────────┐       ┌────────────────┐   │
│   │ API Server            │◄─────►│ Scheduler             │◄─────►│ etcd Cluster   │   │
│   │ (Entry Point for commands)    │ (Chooses which worker │       │ (The Database  │   │
│   └──────────▲────────────┘       │  node gets the Pod)   │       │  of truth)     │   │
│              │                    └───────────────────────┘       └────────────────┘   │
│              │                                                                         │
│              └─────────────────────────────────┐                                       │
│                                                │ (Sends instructions to Kubelet)       │
└────────────────────────────────────────────────┼───────────────────────────────────────┘
                                                 │
  ┌──────────────────────────────────────────────┴────────────────────────────────────┐
  ▼                                                                                   ▼
┌──────────────────────────────────────────────┐    ┌──────────────────────────────────────────────┐
│ WORKER NODE 1 (PC 1 - App Server)            │    │ WORKER NODE 2 (PC 2 - App Server)            │
│                                              │    │                                              │
│  ┌─────────────────┐    ┌─────────────────┐  │    │  ┌─────────────────┐    ┌─────────────────┐  │
│  │ Kubelet Agent   │    │ Kube-Proxy      │  │    │  │ Kubelet Agent   │    │ Kube-Proxy      │  │
│  │ (Node Captain)  │    │ (Network Router)│  │    │  │ (Node Captain)  │    │ (Network Router)│  │
│  └────────┬────────┘    └────────▲────────┘  │    │  └────────┬────────┘    └────────▲────────┘  │
│           │                      │           │    │           │                      │           │
│           ▼ (Starts Pod)         │           │    │           ▼ (Starts Pod)         │           │
│  ┌───────────────────────────────┼────────┐  │    │  ┌───────────────────────────────┼────────┐  │
│  │ POD 1: Node.js App            │        │  │    │  │ POD 2: Node.js App            │        │  │
│  │  - Container (node server.js) │        │  │    │  │  - Container (node server.js) │        │  │
│  │  - IP: 10.244.0.5             │        │  │    │  │  - IP: 10.244.1.9             │        │  │
│  └───────────────────────────────┼────────┘  │    │  └───────────────────────────────┼────────┘  │
│                                  │           │    │                                  │           │
│  ┌───────────────────────────────┼────────┐  │    │                                  │           │
│  │ POD 3: Redis Cache            │        │  │    │                                  │           │
│  │  - Container (redis:7)        │        │  │    │                                  │           │
│  └───────────────────────────────┼────────┘  │    │                                  │           │
└──────────────────────────────────┼───────────┘    └──────────────────────────────────┼───────────┘
                                   │                                                   │
                                   └─────────────── [ INGRESS / BALANCER ] ────────────┘
                                                            ▲
                                                            │
                                                Public Internet Traffic






[ Phase 1: Launch New Pod ]        [ Phase 2: Route & Verify ]       [ Phase 3: Terminate Old Pod ]
┌───────────────────────────────┐  ┌───────────────────────────────┐  ┌───────────────────────────────┐
│ WORKER NODE 1                 │  │ WORKER NODE 1                 │  │ WORKER NODE 1                 │
│  [ Pod v1 ]                   │  │  [ Pod v1 ]                   │  │  [ Pod v1 ]                   │
└───────────────────────────────┘  └───────────────────────────────┘  └───────────────────────────────┘
┌───────────────────────────────┐  ┌───────────────────────────────┐  ┌───────────────────────────────┐
│ WORKER NODE 2                 │  │ WORKER NODE 2                 │  │ WORKER NODE 2                 │
│  [ Pod v1 ]                   │  │  [ Pod v1 ]                   │  │  [ Pod v2 ] ◄─ Upgraded       │
│  [ Pod v2 ] ◄─ New Booting    │  │  [ Pod v2 ] ◄─ Traffic Sent   │  └───────────────────────────────┘
└───────────────────────────────┘  └───────────────────────────────┘  (Old v1 on Worker 2 is safely
(Master commands Kubelet 2 to      (Kube-Proxy shifts user traffic     deleted only after v2 is 100%
 pull and start v2 container)       to v2 once health probe passes)    handling production traffic)



Step 1: The Trigger (Updating the Control Plane)


You run a command or apply a deployment file update to target the Control Plane:

>> kubectl set image deployment/nodejs-app nodejs-container=nodejs-app:v2


This instruction hits the API Server on the Master Node.The API Server records the change into etcd, declaring that the official state of your application is now v2.




