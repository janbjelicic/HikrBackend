#!/bin/bash
swift build -c release --enable-test-discovery
.build/release/Run serve --env production --port 8080
