# Allow clients to register with the server
node {
  policy = "write"
}

# Allow clients to use host volumes
# Update this to Vault host volumes to stop other jobs from claiming it
host_volume "*" {
  policy = "write"
}
