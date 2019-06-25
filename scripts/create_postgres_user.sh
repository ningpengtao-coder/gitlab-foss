#!/bin/bash

psql -h postgres -U postgres postgres <<EOF
CREATE USER gitlab;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO gitlab;
CREATE USER git;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO gitlab;
EOF
