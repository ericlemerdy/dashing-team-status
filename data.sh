#! /bin/bash

curl -d "{ \"auth_token\": \"YOUR_AUTH_TOKEN\", \"mood\": "$(shuf -i 0-4 -n 1)" }" http://localhost:3030/widgets/team-status-data-id
sleep 1s
curl -d "{ \"auth_token\": \"YOUR_AUTH_TOKEN\", \"mood\": "$(shuf -i 0-4 -n 1)" }" http://localhost:3030/widgets/team-status-data-id
sleep 2s
curl -d '{ "auth_token": "YOUR_AUTH_TOKEN", "nextDay": true }' http://localhost:3030/widgets/team-status-data-id
sleep 1s
curl -d "{ \"auth_token\": \"YOUR_AUTH_TOKEN\", \"mood\": "$(shuf -i 0-4 -n 1)" }" http://localhost:3030/widgets/team-status-data-id
sleep 1s
