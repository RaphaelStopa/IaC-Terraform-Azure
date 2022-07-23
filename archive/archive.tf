#Terraform manipulating local files.
# data "archive_file" = Generates an archive from content, a file, or directory of files.

terraform {
  required_providers {
    archive = {
      source = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}



data "archive_file" "arquivozip" {
    type = "zip"
    # source_file = "data_backup/data.txt"
    source_dir = "data_backup"
    output_path = "backup.zip"
}

output "arquivozip" {
    value = data.archive_file.arquivozip.output_size
}