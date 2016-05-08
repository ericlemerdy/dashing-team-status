#!/usr/bin/env bash

read -s -p "Enter Password: " password
echo ""
echo "Dropping existing schema..."
curl -u ericlemerdy:$password -X DELETE https://dashing-luqi.spacedog.io/1/schema/moods
echo ""
echo "Create basic schema..."
curl -u ericlemerdy:$password -d '{
  "moods": {
    "_type": "object",
    "x": {
      "_type": "integer",
      "_required" : true
    },
    "y": {
      "_type": "float",
      "_required" : true
    }
  }
}' https://dashing-luqi.spacedog.io/1/schema/moods
echo ""
echo "Storing a mood..."
curl -u ericlemerdy:$password -d '{
  "x": 123456,
  "y": 2.3
}' https://dashing-luqi.spacedog.io/1/data/moods
echo ""
echo "Getting data..."
curl -u ericlemerdy:$password https://dashing-luqi.spacedog.io/1/data/moods