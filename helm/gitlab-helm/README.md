## Gitlab

Simplifications for a PoC: 

* No Custom Domain: Use a LoadBalancer with the default AWS-generated DNS instead of setting up a domain or ingress with TLS.
* Minimal Configuration: Deploy GitLab with the minimal settings required for a basic functional setup.
* Built-in Database and Redis: Use GitLab's default PostgreSQL and Redis instead of external services.
* No Backup Configuration: Skip S3 or backup configuration for simplicity.