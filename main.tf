provider "rafay" {
  # Configuration options
  profile = "",
  api_key =  "ra2.32ce1e1f34e3787837b3738366547557b9cf90b9.d4d73fd4942d9587616c10c22ce9e4b2d439628dcc19ff59d42be9195aeb9ba6",
  api_secret = "d4d73fd4942d9587616c10c22ce9e4b2d439628dcc19ff59d42be9195aeb9ba6",
  project_id = "kogj642",
  rest_endpoint = "console.rafay.dev",
  ops_endpoint = "ops.rafay.dev"
}
resource "null_resource" "tfc_test" {
  count = 10
  provisioner "local-exec" {
    command = "echo 'Test ${count.index}'"
  }
}
   
