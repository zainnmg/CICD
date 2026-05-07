# CI/CD Learning Lab

This repo is a safe playground for learning three practical CI/CD topics:

- storing variables and secrets
- calling reusable workflows with `workflow_call`
- adding manual inspection gates before a deploy

The workflows are intentionally small and do not deploy real infrastructure. Think of them like a flight simulator: you practise the controls before touching a real production system.

## Repo Map

- `.github/workflows/01-variables-and-calls.yml` runs on push, PR, or manual trigger. It shows workflow-level `env`, job-level `env`, step-level `env`, GitHub Actions variables, GitHub Actions secrets, and a reusable workflow call.
- `.github/workflows/reusable-quality-check.yml` is called by another workflow. It accepts inputs, receives secrets, creates a report, uploads an artifact, and writes a job summary.
- `.github/workflows/02-manual-inspection.yml` is manually triggered. It creates inspection evidence, then pauses at a GitHub Environment if you configure required reviewers.
- `bootstrap/` is a Terraform variable lab. It creates no cloud resources, so it is safe to run locally.

## 1. GitHub Variables And Secrets

GitHub Actions has a few places to store values:

- `env` in a workflow file: good for non-secret values used only by that workflow.
- repository or environment variables: good for non-secret config managed in the GitHub UI, such as `DEFAULT_REGION`.
- secrets: good for sensitive values, such as tokens, passwords, and cloud role ARNs.
- workflow inputs: good for values chosen when you manually run a workflow.

Set these in GitHub:

1. Go to `Settings > Secrets and variables > Actions`.
2. Under `Variables`, add `DEFAULT_REGION` with a value like `eu-west-2`.
3. Under `Secrets`, optionally add `DEMO_API_TOKEN` with any fake value.

Common beginner mistake: putting secrets in YAML files because it feels convenient. Anything committed to Git is hard to fully erase later, even if you delete it in a future commit.

## 2. Run The Variables Workflow

In GitHub, open `Actions > 01 - Variables and Workflow Calls > Run workflow`.

Try these inputs:

- `target_environment`: `dev`
- `release_version`: `demo-1`
- `run_manual_deploy_preview`: `true`

What happens:

- the first job prints safe variable information
- the second job calls `.github/workflows/reusable-quality-check.yml`
- the reusable workflow creates an inspection artifact
- the optional final job shows what a dry-run deploy step might look like

The key syntax is:

```yaml
jobs:
  call-reusable-quality-check:
    uses: ./.github/workflows/reusable-quality-check.yml
    with:
      service_name: "demo-api"
    secrets: inherit
```

Why this matters: reusable workflows stop teams copying the same CI logic into every repo. It is similar to a Terraform module or a shell function: define the pattern once, then call it with different inputs.

## 3. Manual Inspection Gates

The workflow `.github/workflows/02-manual-inspection.yml` demonstrates three manual inspection methods:

- `workflow_dispatch` inputs let a human choose the target environment and release version.
- artifacts give reviewers something concrete to download and inspect.
- GitHub Environments can require approval before a job starts.

To make the approval gate real:

1. Go to `Settings > Environments`.
2. Create environments named `dev`, `staging`, and `prod`.
3. Open `prod`.
4. Enable `Required reviewers`.
5. Add yourself or a teammate.

Then run `Actions > 02 - Manual Inspection Gate > Run workflow` and choose `prod`.

Important: if you do not configure required reviewers on the environment, GitHub will not pause. The workflow still runs, but there is no human approval gate.

## 4. Terraform Variable Lab

The `bootstrap/` folder teaches Terraform variables without creating AWS resources.

Run this:

```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

Line by line:

- `cd bootstrap` moves into the Terraform lab folder.
- `cp terraform.tfvars.example terraform.tfvars` creates your local variable file.
- `terraform init` downloads Terraform providers and prepares the working directory.
- `terraform plan` evaluates the config and shows outputs without changing real infrastructure.

Try overriding a variable from the command line:

```bash
terraform plan -var="environment=prod" -var="image_tag=abc123"
```

Try passing a sensitive variable through the environment:

```bash
export TF_VAR_demo_api_token="fake-token-for-learning"
terraform plan
```

Why this matters: Terraform variable precedence is a lot like layered config in CI/CD. Defaults are the baseline, `terraform.tfvars` is local config, `-var` is an explicit override, and `TF_VAR_` environment variables are useful for automation.

Common beginner mistake: committing `terraform.tfvars`. It often starts with harmless values, then later gets real account IDs, tokens, or passwords. This repo ignores it on purpose.

## Practice Ideas

- Add another input to `01-variables-and-calls.yml` and pass it into the reusable workflow.
- Configure a `prod` environment with required reviewers and observe where GitHub pauses.
- Change `bootstrap/variables.tf` validation so only `staging` and `prod` are allowed, then run `terraform plan` with `environment=dev` to see the failure.
- Add a fake security scan step that fails when `target_environment` is `prod` and `release_version` is `latest`.

What to read next: GitHub Actions docs for `workflow_call`, GitHub Environments, and Terraform variable precedence.