#!/bin/bash
set -euo pipefail

POD=$(kubectl get pods --selector=app==bookapi -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | tail -n 1)

if [ -z "$POD" ]; then
    echo "No pod available to run migrations."
    exit 1;
else
    kubectl exec -ti $POD npm run knex migrate:latest
fi
