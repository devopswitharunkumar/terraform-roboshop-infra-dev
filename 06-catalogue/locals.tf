locals {
  name = "${var.Project_Name}-${var.Environment}"
  current_date = formatdate("YYYY-MM-DD-hh-mm", timestamp())
}

