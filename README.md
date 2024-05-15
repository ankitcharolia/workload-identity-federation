# Configure OpenID Connect with GCP Workload Identity Federation

This tutorial demonstrates authenticating to Google Cloud from a GitLab CI/CD job using a JSON Web Token (JWT) token and Workload Identity Federation. This configuration generates on-demand, short-lived credentials without needing to store any secrets.

### Steps: [Workload Identity Federation](https://console.cloud.google.com/iam-admin/workload-identity-pools)

**Create Workload Identity Federation Pool**
1. Create a new Workload Identity Pool named `GitLab` with the ID `gitlab`
2. Select `OpenID Connect (OIDC)` as Provider

**Add Workload Identity Federation Provider to the Pool (multiple providers can be added in a pool)**
1. Select `OpenID Connect (OIDC)` as provider
2. Write a new Workload Identity Provider named `Gitlab Test` with the ID `gitlab-test`
3. Issuer URL: `https://gitlab.com/` (with trailing slash)
3. keep the default audience. (Add if needed)
  
    **NOTE:**
    * The address must use the https:// protocol.
    * The address must not end in a trailing slash.
4. Configure the provider attributes mapping
    
    `google.subject` to `assertion.sub` 

    `attribute.project_path` to `assertion.project_path` 
5. save it.

**Grant permissions for Service Account impersonation**
1. Create a new service account named `gitlab-test`
2. Grant IAM permissions
    `For example, if you needed to upload a file to a Google Cloud Storage bucket in your GitLab CI/CD job, you would grant this Service Account the roles/storage.objectCreator role on your Cloud Storage bucket.`
3. Grant the external identity permission using the following command. External identities are expressed using the principalSet:// protocol.

    `gcloud iam service-accounts add-iam-policy-binding gitlab-test@<gcp-project>.iam.gserviceaccount.com --role=roles/iam.workloadIdentityUser --member="principalSet://iam.googleapis.com/projects/906410504594/locations/global/workloadIdentityPools/gitlab/attribute.project_path/<gitlab-repository-path>"`

    **EXAMPLE**

    `gcloud iam service-accounts add-iam-policy-binding gitlab-test@<gcp-project>.iam.gserviceaccount.com --role=roles/iam.workloadIdentityUser --member="principalSet://iam.googleapis.com/projects/906410504594/locations/global/workloadIdentityPools/gitlab/attribute.project_path/ankitcharolia/gitlab-workload-identity"`

### rollout this tf module
```bash
inputs = {
    workload_identity_pool_id           = "gitlab-ci"
    workload_identity_pool_display_name = "gitlab-ci"
    workload_identity_pool_provider_id  = "terraform"
    service_account_name                = "gitlab-ci"
    service_account_display_name        = "gitlab-ci"
    service_account_description         = "service account for gitlab-ci"
}
```

# Reference
* [OpenID Connect](https://gitlab.com/guided-explorations/gcp/configure-openid-connect-in-gcp)
* [github-actions WIF](https://nakamasato.medium.com/setup-github-actions-and-terraform-for-a-new-gcp-project-b740f561107)
