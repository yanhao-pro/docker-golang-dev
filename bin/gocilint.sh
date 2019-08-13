#!/usr/bin/zsh

golangci-lint run --print-issued-lines=false --enable=govet --enable=gofmt --deadline=30s
