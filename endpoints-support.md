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
|     **FC Networks**                                                                                                                               |
|<sub>/rest/fc-networks</sub>                                                             | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fc-networks</sub>                                                             | POST     | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fc-networks/{id}</sub>                                                        | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fc-networks/{id}</sub>                                                        | PATCH    | :heavy_minus_sign:   | :white_check_mark:   | :white_check_mark:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   | :heavy_minus_sign:   |
|<sub>/rest/fc-networks/{id}</sub>                                                        | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
|<sub>/rest/fc-networks/{id}</sub>                                                        | DELETE   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |
