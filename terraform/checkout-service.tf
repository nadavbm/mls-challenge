resource "google_service_account" "checkout" {
  account_id   = "checkout-service"
  display_name = "checkout-service"
  project      = var.project_id
}

resource "google_storage_bucket" "receipts" {
  name                        = "ml-checkout-receipts"
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

resource "google_project_iam_member" "checkout_storage" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.checkout.email}"
}

resource "google_service_account_iam_member" "checkout_workload_identity" {
  service_account_id = google_service_account.checkout.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[default/checkout-service]"
}
