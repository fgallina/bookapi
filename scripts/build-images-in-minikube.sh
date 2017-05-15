#!/bin/bash
set -euo pipefail

eval $(minikube docker-env)
make build
