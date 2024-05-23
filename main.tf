

variable "gh_token" {
  description = "A github PAT with permission for creating and configuring repos."
  type        = string
  sensitive   = true
}

provider "github" {
  token = var.gh_token # or `GITHUB_TOKEN`
}

resource "null_resource" "always_replace" {
  triggers = {
    always = timestamp()
  }
}

resource "github_repository" "example" {
  name        = "tf-driven-repo-example"
  description = "My awesome codebase!"

  visibility = "private"

  auto_init = true

  lifecycle {
    replace_triggered_by = [ null_resource.always_replace ]
  }
}

resource "github_repository_file" "file1" {
  repository          = github_repository.example.name
  branch              = "main"
  file                = "file1"
  content             = file("file1")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

resource "github_release" "file1release" {
  repository = github_repository.example.name
  tag_name   = "file1"
  draft      = false
  prerelease = false

  depends_on = [ github_repository_file.file1 ]
}

resource "github_repository_file" "file2" {
  repository          = github_repository.example.name
  branch              = "main"
  file                = "file2"
  content             = file("file2")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

  depends_on = [ github_release.file1release ]
}

resource "github_release" "file2release" {
  repository = github_repository.example.name
  tag_name   = "file2"
  draft      = false
  prerelease = false

  depends_on = [ github_repository_file.file2 ]
}

output "fonestar" {
    value = fileset(".", "f*")
}

output "fallstar" {
    value = fileset(".", "**/f**")
}
