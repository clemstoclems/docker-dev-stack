#!/bin/bash
CUSTOM_ELASTIC_WAIT_TIME=3
CUSTOM_ELASTIC_HTTP_OK=200
CREDENTIAL_OPTION=()

if [ -n "${ELASTICSEARCH_USERNAME}" ] && [ -n "${ELASTICSEARCH_PASSWORD}" ]
then
  CREDENTIAL_OPTION=( -u ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} )
fi

until test "$(curl -s -o /dev/null "${CREDENTIAL_OPTION[@]}" -w "%{http_code}\n" "${ELASTICSEARCH_HOSTS}")" -eq ${CUSTOM_ELASTIC_HTTP_OK}; do
  >&2 echo "Elasticsearch is unavailable - sleeping"
  sleep ${CUSTOM_ELASTIC_WAIT_TIME}
done

>&2 echo "Elasticsearch is up"

until test "$(curl -s -o /dev/null "${CREDENTIAL_OPTION[@]}" -w "%{http_code}\n" http://localhost:5601/api/spaces/space)" -eq ${CUSTOM_ELASTIC_HTTP_OK}; do
  >&2 echo "Kibana api is unavailable - sleeping"
  sleep ${CUSTOM_ELASTIC_WAIT_TIME}
done

>&2 echo "Kibana is up"

if [ "$(curl -s -o /dev/null "${CREDENTIAL_OPTION[@]}" -w "%{http_code}\n" "http://localhost:5601/api/saved_objects/index-pattern/${CUSTOM_INDEX_PATTERN}")" -ne ${CUSTOM_ELASTIC_HTTP_OK} ]
then
  >&2 echo "Creating custom index pattern : ${CUSTOM_INDEX_PATTERN}"

  curl -s "${CREDENTIAL_OPTION[@]}" -X POST "http://localhost:5601/api/saved_objects/index-pattern/${CUSTOM_INDEX_PATTERN}" \
    -H "Content-Type: application/json" \
    -H "kbn-xsrf:true"  \
    -d "{ \"attributes\": { \"title\":\"${CUSTOM_INDEX_PATTERN}*\", \"timeFieldName\":\"@timestamp\"}}"
else
  >&2 echo "Custom index pattern already exists : ${CUSTOM_INDEX_PATTERN}"
fi
