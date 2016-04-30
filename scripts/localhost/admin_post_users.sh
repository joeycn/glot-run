#!/bin/bash

curl -sv -H "Authorization: Token clumeterin" -H 'Content-type: application/json' -X POST -d '{"token": "C32BE915-38E8-486C-96DB-28C71EA87E42"}' localhost:8090/admin/users | jq .
