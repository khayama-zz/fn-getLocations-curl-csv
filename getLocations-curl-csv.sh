#!/bin/bash
ARGS=$@
SL_USER=`echo "$ARGS" | jq -r '."SL_USER"'`
SL_APIKEY=`echo "$ARGS" | jq -r '."SL_APIKEY"'`

LOCATIONS=`curl -u "$SL_USER:$SL_APIKEY" -X GET 'https://api.softlayer.com/rest/v3.1/SoftLayer_Location/getViewablePopsAndDataCenters.json?objectMask=mask%5BlongName%2Cname%2ClocationAddress%5BlocationId%2Caddress1%2Caddress2%2Ccity%2Ccountry%2CisActive%2CpostalCode%2Cstate%2Ctype%5BkeyName%5D%5D%5D'| jq -r '.[] | [.longName, .name, .locationAddress.type.keyName, .locationAddress.address1, .locationAddress.city, .locationAddress.state, .locationAddress.country, .locationAddress.postalCode] |@csv'`

echo "{ \"headers\": { \"Content-Type\": \"text/csv\", \"Content-Disposition\" : \"attachment; filename=ibmcloud_dc_pop_address.csv\" }, \"statusCode\": 200, \"body\": $(LOCATIONS="$LOCATIONS" jq -n 'env.LOCATIONS') }"

