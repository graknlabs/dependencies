#!/bin/bash

echo "Installing RBE credential..."
if [[ -n "$BAZEL_RBE_CREDENTIAL" ]]; then
    BAZEL_RBE_CREDENTIAL_LOCATION=~/.config/gcloud/application_default_credentials.json
    echo "An RBE credential is found and will be saved to $BAZEL_RBE_CREDENTIAL_LOCATION. Bazel will be executed with RBE support."
    mkdir -p ~/.config/gcloud/
    echo $BAZEL_RBE_CREDENTIAL > "$BAZEL_RBE_CREDENTIAL_LOCATION"
    echo "The RBE credential has been installed!"
else
    echo "No RBE credential found. Bazel will be executed locally without RBE support."
fi
