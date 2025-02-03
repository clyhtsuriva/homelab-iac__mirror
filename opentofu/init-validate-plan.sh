#!/usr/bin/env bash

plan_file="$1"

# tofu workflow
tofu init && \
tofu fmt && \
tofu validate && \
tofu plan -out "$plan_file"
