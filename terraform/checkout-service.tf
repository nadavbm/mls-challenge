resource "google_service_account" "checkout" {
  account_id   = "checkout-service"
  display_name = "checkout-service"
  project      = var.project_id
}

resource "google_storage_bucket" "receipts" {
  name                        = "ml-checkout-reciepts"
  project                     = var.project_id
  location                    = "EU"
  uniform_bucket_level_access = true
  force_destroy               = true

  lifecycle_rule {
    condition {
      age = 2555
    }
    action {
      type = "Delete"
    }
  }
}
