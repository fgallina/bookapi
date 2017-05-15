# NodeJS RESTful API + Postgres + Docker + Kubernetes

This is just a toy project that dockerizes a simple Book API service.

It also contains an example Kubernetes configuration to deploy it with
2 Nginx frontends, 3 app servers and a Postgres master. All these
numbers are arbitrary and are defined for the sake of experimentation.

# Usage

## Requirements

- GNU Make (available in your package manager of preference)

If you wish to play with it without locally installing Postgres and
Node you can take advantage of `docker` and `docker-compose` which
would help you build the container images and setup a working
environment for you:

- Docker: https://docs.docker.com/engine/installation/
- Docker Compose: https://docs.docker.com/compose/install/

If you want to try this out within a Kubernetes environment this is
all you need:

- Kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/
- Minikube: https://kubernetes.io/docs/tasks/tools/install-minikube/

## Usage with Docker

Once `docker` and `docker-compose` are installed run `make up`.

This will trigger the pulling and building of the necessary images and
will use `docker-compose` to setup the app and the Postgres
containers.

Once the Postgres container starts up (note that it may take a few
minutes until it starts accepting connections the first time) you can
run the database migrations with the `make migrate` command.

After everything is up and running you can start hitting the API
server via port `3000` like so:

    curl -X POST http://localhost:3000/books \
        -H 'Content-Type: application/json' \
        -d '{"title": "Martín Fierro", "author": "José Hernandez"}'

The Postgres database data directory is setup to be mounted in the
`pgdata` directory at the root of the project. In case you want to
start afresh just issue `make clean-db`.

## Usage with Minikube + Kubernetes

Once `minikube` is running (via `minikube start`), you can trigger a
deployment with `make kube-deploy`. This command will take care of
building the images inside the Minikube internal docker registry and
make it available for deploy. It would also apply all YAML files
inside of the `deploy/` directory.

Similarly to the Docker workflow, once the Postgres service is up, you
should run database migrations with `make kube-migrate`.

Once everything is up, you can hit the API like so:

    curl -X POST $(minikube service nginx --url | head -n 1)/books \
        -H 'Content-Type: application/json' \
        -d '{"title": "Martín Fierro", "author": "José Hernandez"}'

The Nginx service has two ports open, the first for `http` and the
second for `https` traffic. Should you want to try SSL, use:

    curl -k -X POST $(minikube service nginx --url | tail -n 1 | sed 's/http:/https:/')/books \
        -H 'Content-Type: application/json' \
        -d '{"title": "Martín Fierro", "author": "José Hernandez"}'

Note the current deploy does not mount the database volume in any
persistent place.

# Project structure

## API server files

Just the usual `package.js`, `knexfile.js` and everything inside the
`migrations` and `api` directories.

## Docker files

The app server image has been split in two images: first is the
dependencies image defined in the `Dockerfile.dependencies` file which
only gets rebuilt whenever `package.json` is changed; the second is
the image for the app code itself which is defined in `Dockerfile.app`
which re-uses the dependencies image and starts the server.

For convenience the `Makefile` defines the `build-deps` and
`build-app` targets to build images from such Dockerfiles. The `build`
target will take care of building both automatically.

## Kubernetes

All deployment YAML files live under the `deploy/` directory and are
named with a suffix matching the type they define.

The `Makefile` provides two convenience targets to aid into the
deployment of the API. The first one `kube-build` which only builds
the images inside the `minikube` docker registry and `kube-deploy`
which applies all YAML deployment files through `kubectl`.

# API endpoints

## List

    GET /books


    Returns a list of book objects

    [
        {
            "id": 1,
            "slug": "Martin-Fierro",
            "title": "Martín Fierro",
            "author": "José Hernández",
            "publisher": "",
            "created_at": "2017-05-15T03:39:25.773Z",
            "updated_at": "2017-05-15T03:39:25.773Z"
        }
    ]

## Create

    POST /books
    Content-Type: application/json

    {"title": "Martín Fierro", "author": "José Hernández"}


    Returns the book object if created

    {
        "id": 1,
        "slug": "Martin-Fierro",
        "title": "Martín Fierro",
        "author": "José Hernández",
        "publisher": "",
        "created_at": "2017-05-15T03:39:25.773Z",
        "updated_at": "2017-05-15T03:39:25.773Z"
    }

## Read

    GET /books/<slug>


    Returns the book object if it exists (otherwise 404)

    {
        "id": 1,
        "slug": "Martin-Fierro",
        "title": "Martín Fierro",
        "author": "José Hernández",
        "publisher": "",
        "created_at": "2017-05-15T03:39:25.773Z",
        "updated_at": "2017-05-15T03:39:25.773Z"
    }

## Update

    PUT /books/<slug>
    Content-Type: application/json

    {"Publisher": "Editorial Lozada"}


    Returns the updated book object if it exists (otherwise 404)

    {
        "id": 1,
        "slug": "Martin-Fierro",
        "title": "Martín Fierro",
        "author": "José Hernández",
        "publisher": "Editorial Lozada",
        "created_at": "2017-05-15T03:39:25.773Z",
        "updated_at": "2017-05-15T03:42:04.251Z"
    }

## Delete

    DELETE /books/<slug>
    Content-Type: application/json


    Returns the deleted book object if it existed (otherwise 404)

    {
        "id": 1,
        "slug": "Martin-Fierro",
        "title": "Martín Fierro",
        "author": "José Hernández",
        "publisher": "Editorial Lozada",
        "created_at": "2017-05-15T03:39:25.773Z",
        "updated_at": "2017-05-15T03:42:04.251Z"
    }
