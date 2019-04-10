#!/usr/bin/env bats

load helpers

@test "s1 proxy admin is up on :19000" {
  retry 5 1 curl -f -s localhost:19000/stats -o /dev/null
}

@test "s2 proxy admin is up on :19001" {
  retry 5 1 curl -f -s localhost:19001/stats -o /dev/null
}

@test "s1 proxy listener shoudl be up and have right cert" {
  assert_proxy_presents_cert_uri localhost:21000 s1
}

@test "s2 proxy listener shoudl be up and have right cert" {
  assert_proxy_presents_cert_uri localhost:21001 s2
}

@test "s1 upstream should be able to connect to s2" {
  run curl -s -f -d hello localhost:5000
  [ "$status" -eq 0 ]
  [ "$output" = "hello" ]
}
