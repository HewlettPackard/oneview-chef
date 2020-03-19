***Legend***

| Item | Meaning |
| ------------------ | --------------------------------------------- |
|  :white_check_mark: | Endpoint implemented in the Chef SDK and tested for this API version :tada: |
|  :heavy_multiplication_x:  | Endpoint considered as 'out-of-scope' for the Chef SDK               |
|  :heavy_minus_sign: | Endpoint not available for this API Version |

<br />

***Notes***

* If an endpoint is marked as implemented in a previous version of the API, it will likely already be working for newer API versions, however in these cases it is important to:
1. Specify the 'type' of the resource when using an untested API, as it will not get set by default
2. If an example is not working, verify the [HPE OneView REST API Documentation](https://techlibrary.hpe.com/docs/enterprise/servers/oneview5.0/cicf-api/en/index.html#)  for the API version being used, since the expected attributes for that resource might have changed.

<br />

## HPE OneView
| Endpoints                                                                       | Verb     | V200 | V300 | V500 |V600 |V800 | V1000 | V1200 |
| --------------------------------------------------------------------------------------- | -------- | :------------------: | :------------------: | :------------------: | :------------------: | :------------------: | :------------------: | :------------------: |
|     **Connection Templates**                                                                                                  |
|<sub>/rest/connection-templates</sub>                                                    |GET          | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/connection-templates/defaultConnectionTemplate</sub>                          |GET          | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/connection-templates/{id}</sub>                                               |GET          | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/connection-templates/{id}</sub>                                               |PUT          | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|     **Enclosures**                                                                                                                                |
|<sub>/rest/enclosures</sub>                                                              | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures</sub>                                                              | POST     | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}</sub>                                                         | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}</sub>                                                         | PATCH    | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}</sub>                                                         | DELETE   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}/configuration</sub>                                           | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}/environmentalConfiguration</sub>                              | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}/environmentalConfiguration</sub>                              | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}/refreshState</sub>                                            | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}/script</sub>                                                  | GET      | :white_check_mark:   | :white_check_mark:   | :heavy_minus_sign:   | :heavy_minus_sign:   |:heavy_minus_sign:   |:heavy_minus_sign:   |:heavy_minus_sign:   |
|<sub>/rest/enclosures/{id}/sso</sub>                                                     | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}/utilization</sub>                                             | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}/https/certificaterequest</sub>                                | POST     | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}/https/certificaterequest</sub>                                | GET      | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/enclosures/{id}/https/certificaterequest</sub>                                | PUT      | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|**Ethernet Networks**                                                                                                                         |
|<sub>/rest/ethernet-networks</sub>                                                       | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/ethernet-networks</sub>                                                       | POST     | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/ethernet-networks/{id}</sub>                                                  | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/ethernet-networks/{id}</sub>                                                  | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/ethernet-networks/{id}</sub>                                                  | PATCH    | :heavy_minus_sign:   | :white_check_mark:   | :white_check_mark:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   |
|<sub>/rest/ethernet-networks/{id}</sub>                                                  | DELETE   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |  
|     **FC Networks**                                                                                                                               |
|<sub>/rest/fc-networks</sub>                                                             | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fc-networks</sub>                                                             | POST     | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fc-networks/{id}</sub>                                                        | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fc-networks/{id}</sub>                                                        | PATCH    | :heavy_minus_sign:   | :white_check_mark:   | :white_check_mark:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   |
|<sub>/rest/fc-networks/{id}</sub>                                                        | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fc-networks/{id}</sub>                                                        | DELETE   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|     **FCoE Networks**                                                                                                                             |
|<sub>/rest/fcoe-networks</sub>                                                           | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fcoe-networks</sub>                                                           | POST     | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fcoe-networks/{id}</sub>                                                      | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fcoe-networks/{id}</sub>                                                      | PATCH    | :heavy_minus_sign:   | :white_check_mark:   | :white_check_mark:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   |
|<sub>/rest/fcoe-networks/{id}</sub>                                                      | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fcoe-networks/{id}</sub>                                                      | DELETE   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|     **Logical Interconnect Groups**                                                                                                               |
|<sub>/rest/logical-interconnect-groups</sub>                                             | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/logical-interconnect-groups</sub>                                             | POST     | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/logical-interconnect-groups/{id}</sub>                                        | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/logical-interconnect-groups/{id}</sub>                                        | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/logical-interconnect-groups/{id}</sub>                                        | PATCH    | :heavy_minus_sign: | :white_check_mark: | :white_check_mark: |  :heavy_minus_sign:   |:heavy_minus_sign:   |:heavy_minus_sign:   |:heavy_minus_sign:   |
|<sub>/rest/logical-interconnect-groups/{id}</sub>                                        | DELETE   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|**Network Sets**                                                                                                                              |
|<sub>/rest/network-sets</sub>                                                            | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/network-sets</sub>                                                            | POST     | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:  |:white_check_mark:   | :white_check_mark:   |
|<sub>/rest/network-sets/{id}</sub>                                                       | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:  | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/network-sets/{id}</sub>                                                       | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:  | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/network-sets/{id}</sub>                                                       | DELETE   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:  | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/network-sets/{id}</sub>                                                       | PATCH    | :heavy_minus_sign: | :white_check_mark: | :white_check_mark: | :heavy_minus_sign: |:heavy_minus_sign: | :heavy_minus_sign: | :heavy_minus_sign: |
|      **Storage Pools**
|<sub>/rest/storage-pools</sub>                                                           | GET      | :white_check_mark:   | :white_check_mark: | :white_check_mark:
|<sub>/rest/storage-pools</sub>                                                           | POST     | :heavy_minus_sign:   | :heavy_minus_sign: | :heavy_minus_sign:
|<sub>/rest/storage-pools/reachable-storage-pools</sub>                                   | GET      | :white_check_mark:   | :white_check_mark: | :white_check_mark:
|<sub>/rest/storage-pools/{id}</sub>                                                      | GET      | :white_check_mark:   | :white_check_mark: | :white_check_mark:
|<sub>/rest/storage-pools/{id}</sub>                                                      | PUT      | :white_check_mark:   | :white_check_mark: | :white_check_mark:
|<sub>/rest/storage-pools/{id}</sub>                                                      | DELETE   | :heavy_minus_sign:   | :heavy_minus_sign: | :heavy_minus_sign:
|     **Storage Systems**
|<sub>/rest/storage-systems</sub>                                                         | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-systems</sub>                                                         | POST     |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-systems/host-types</sub>                                              | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-systems/{arrayId}/storage-pools</sub>                                 | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-systems/{id}</sub>                                                    | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-systems/{id}</sub>                                                    | PUT      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-systems/{id}</sub>                                                    | DELETE   |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-systems/{id}/managedPorts</sub>                                       | GET      |  :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   |
|<sub>/rest/storage-systems/{id}/managedPorts/{portId}</sub>                              | GET      |  :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   |
|<sub>/rest/storage-systems/{id}/reachable-ports</sub>                                    | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-systems/{id}/templates</sub>                                          | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|     **Storage Volume Templates**
|<sub>/rest/storage-volume-templates</sub>                                                | GET      | :white_check_mark: | :white_check_mark: | :white_check_mark:
|<sub>/rest/storage-volume-templates</sub>                                                | POST     | :white_check_mark: | :white_check_mark: | :white_check_mark:
|<sub>/rest/storage-volume-templates/connectable-volume-templates</sub>                   | GET      | :heavy_minus_sign: | :heavy_minus_sign: | :heavy_minus_sign:
|<sub>/rest/storage-volume-templates/reachable-volume-templates</sub>                     | GET      | :white_check_mark: | :white_check_mark: | :white_check_mark:
|<sub>/rest/storage-volume-templates/{id}</sub>                                           | GET      | :white_check_mark: | :white_check_mark: | :white_check_mark:
|<sub>/rest/storage-volume-templates/{id}</sub>                                           | PUT      | :white_check_mark: | :white_check_mark: | :white_check_mark:
|<sub>/rest/storage-volume-templates/{id}</sub>                                           | DELETE   | :white_check_mark: | :white_check_mark: | :white_check_mark:
|<sub>/rest/storage-volume-templates/{id}/compatible-systems</sub>                        | GET      | :white_check_mark: | :white_check_mark: | :white_check_mark:   
|     **Uplink Sets**                                                                                                                              |
|<sub>/rest/uplink-sets</sub>                                                             | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/uplink-sets</sub>                                                             | POST     | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/uplink-sets/{id}</sub>                                                        | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/uplink-sets/{id}</sub>                                                        | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/uplink-sets/{id}</sub>                                                        | DELETE   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|     **Volumes**
|<sub>/rest/storage-volumes</sub>                                                         | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes</sub>                                                         | POST     |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/attachable-volumes</sub>                                      | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/from-existing</sub>                                           | POST     |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/from-snapshot</sub>                                           | POST     |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/repair</sub>                                                  | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/repair</sub>                                                  | POST     |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/{id}</sub>                                                    | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/{id}</sub>                                                    | PUT      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/{id}</sub>                                                    | DELETE   |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/{id}/snapshots</sub>                                          | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/{id}/snapshots</sub>                                          | POST     |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/{id}/snapshots/{snapshotId}</sub>                             | GET      |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/storage-volumes/{id}/snapshots/{snapshotId}</sub>                             | DELETE   |  :white_check_mark:   | :white_check_mark:   | :white_check_mark:
