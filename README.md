glot-run
========


## Overview
glot-run provides a http api for running code inside docker containers.
The api is described [here](https://github.com/prasmussen/glot-run/tree/master/api_docs).

### Downloads
- [glot-run-linux-x64.tar.gz v1.0.0](https://drive.google.com/uc?id=0B3X9GlR6EmbnWHlMWTBkM3daUE0)

## Run
The download above is a standard erlang release that includes a start script.
To start glot-run in the foreground type: `glot/bin/glot foreground`.

## Environment variables
glot-run takes it's configuration from environment variables.
All vars needs to be set, no default values are provided.

| Variable name        | Allowed values                | Example             | Description                                                   |
|:---------------------|:------------------------------|:--------------------|:--------------------------------------------------------------|
| API_ENVIRONMENT      | development &#124; production | production          | Development mode will enable auto compiling of changed files  |
| API_HTTP_LISTEN_IP   | &lt;ipv4 address&gt;          | 0.0.0.0             | Listen ip                                                     |
| API_HTTP_LISTEN_PORT | 1-65535                       | 8090                | Listen port                                                   |
| DATA_PATH            | &lt;filepath&gt;              | /home/app/data/     | Path to save data files (users, languages)                    |
| LOG_PATH             | &lt;filepath&gt;              | /home/app/log/      | Path to save logs                                             |
| BASE_URL             | &lt;url&gt;                   | https://run.glot.io | Base url to where the api is hosted                           |
| ADMIN_TOKEN          | &lt;string&gt;                | some-secret         | Admin token used to access the /admin endpoints               |
| DOCKER_API_URL       | &lt;url&gt;                   | http://10.0.0.125   | Url to docker api (must be available through port 80 for now) |
| DOCKER_RUN_TIMEOUT   | &lt;seconds&gt;               | 30                  | Maximum number of seconds a container is allowed to run       |

## Api users
An api token is required to run code. Users can be created with the `/admin/users` endpoint.
See the [api docs](https://github.com/prasmussen/glot-run/tree/master/api_docs/admin) for more details.

## Languages
Languages can be added with the `/admin/languages` endpoint. A language has
a name, version and the name of a docker image that will be used when running
code for the given language/version.
See the [api docs](https://github.com/prasmussen/glot-run/tree/master/api_docs/admin) for more details.

## Docker images
When a run request is posted to glot-run it will create a new temporary container from
the image that handles the given language/version. The container is required
to listen for a json payload on stdin and must write the run result to stdout
as a json object containing the properties: stdout, stderr and error.
An application that does this is [glot-code-runner](https://github.com/prasmussen/glot-code-runner).
Example images can be found [here](https://github.com/prasmussen/glot-containers).

### Container payload
The payload `{"files": [{"name": "main.py", "content": "print(42)"}]}` posted to
`/languages/python/latest` will result in this payload being sent to the
container: `{"language": "python", "files": [{"name": "main.py", "content": "print(42)"}]}`.
A successful run should yield this response from the container: `{"stdout": "42\n", "stderr": "", "error": ""}`.

## Docker configuration
By default the docker api is only available through a unix socket and it needs
to be configured to listen on a tcp socket. On ubuntu this can be done by
adding the line `DOCKER_OPTS="-H tcp://0.0.0.0:80 -H unix:///var/run/docker.sock"`
to `/etc/default/docker`.
