#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the MIT License. See the LICENSE accompanying this file
# for the specific language governing permissions and limitations under
# the License.

INTERFACE=eth2
PREFIX=192.168.10.0/24
INTERFACE=eth2
ACTION=add
HWADDR=41:b0:34:f0:ac:bc

ETCDIR=./test-output/etc

. ../ec2net-functions
. ./test-functions

ec2dhcp_config() {
  rewrite_rules
  # This can be done asynchronously, to save boot time
  # since it doesn't affect the primary address
  rewrite_aliases &
}

ec2dhcp_restore() {
  remove_aliases
  remove_rules
}

ec2dhcp_config
