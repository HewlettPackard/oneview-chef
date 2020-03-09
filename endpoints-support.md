***Legend***

| Item | Meaning |
| ------------------ | --------------------------------------------- |
|  :white_check_mark: | Endpoint implemented in the Chef SDK for this API version :tada: |
|  :heavy_multiplication_x: | Endpoint considered as 'out-of-scope' for the Chef SDK |
|  :heavy_minus_sign: | Endpoint not available for this API Version |

<br />

***Notes***

* If an endpoint is not marked as implemented for a specific API, it can still be used in compatibility mode for the supported API versions.
* If an example is not working on a supported API version, verify the [HPE OneView REST API Documentation](https://techlibrary.hpe.com/docs/enterprise/servers/oneview5.0/cicf-api/en/index.html)  for the API version being used, since the expected attributes for that resource might have changed.
<br />

## HPE OneView
| Endpoints                                                                       | Verb     | V200 | V300 | V500 |V600 |V800 | V1000 | V1200 |
| --------------------------------------------------------------------------------------- | -------- | :------------------: | :------------------: | :------------------: | :------------------: | :------------------: | :------------------: | :------------------: |
|     **Server Hardware Types**                                                                                                                     |
|<sub>/rest/server-hardware-types</sub>                                                   | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/server-hardware-types/{id}</sub>                                              | GET      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/server-hardware-types/{id}</sub>                                              | PUT      | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |
|<sub>/rest/server-hardware-types/{id}</sub>                                              | DELETE   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   | :white_check_mark:   |:white_check_mark:   |:white_check_mark:   |:white_check_mark:   |

