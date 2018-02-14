#!/bin/bash

# Wait for postgres to start. This works because the database will return an
# empty response to an HTTP request when it's ready to start accepting
# connections. This comes at the cost of an error message in the postgres logs,
# but it isn't detructive and is better than intalling all of postgres just for
# pg_isready.
until curl http://db:5432/ 2>&1 | grep -q '52'
do
  sleep 1
done