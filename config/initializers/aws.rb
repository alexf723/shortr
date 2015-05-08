Aws.config.update({
  region: 'us-west-2'
})
Aws.config[:ssl_verify_peer] = false