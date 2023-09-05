#!/bin/sh -x


PAYLOAD="$(cat <<EOF
{
  "audience": "//iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL_ID/providers/PROVIDER_ID",
  "grantType": "urn:ietf:params:oauth:grant-type:token-exchange",
  "requestedTokenType": "urn:ietf:params:oauth:token-type:access_token",
  "scope": "https://www.googleapis.com/auth/cloud-platform",
  "subjectTokenType": "urn:ietf:params:oauth:token-type:jwt",
  "subjectToken": "${GITLAB_OIDC_TOKEN}"
}
EOF
)"

FEDERATED_TOKEN="$(curl --fail "https://sts.googleapis.com/v1/token" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data "${PAYLOAD}" \
  | jq -r '.access_token'
)"

ACCESS_TOKEN="$(curl --fail "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/SERVICE_ACCOUNT_EMAIL:generateAccessToken" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer ${FEDERATED_TOKEN}N" \
  --data '{"scope": ["https://www.googleapis.com/auth/cloud-platform"]}' \
  | jq -r '.accessToken'
)"