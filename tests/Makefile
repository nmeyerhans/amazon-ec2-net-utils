# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the MIT License. See the LICENSE accompanying this file
# for the specific language governing permissions and limitations under
# the License.
#
# This file provides a common interface to execute the various tests.

TESTS=eth0-basic secondary-basic secondary-more-ips
SCRIPTS=ec2ifup ec2dhcp.sh ec2ifdown

define do-tests
 $(foreach t,${SCRIPTS},
   $(call do-test,${1},${t})
  )
endef

define do-test
  PARAMS=./params-${1}.sh ./test-${2} 2> test-output/${2}.out
endef

define compare-outputs
  $(foreach t,${SCRIPTS},
    $(call compare-output,${1},${t})
  )
endef

define compare-output
  diff -u tdata/${1}/${2}.out test-output/${2}.out
endef

%:
	mkdir -p test-output
	$(call do-tests,$@)
	$(call compare-outputs,$@)

# Use this to update the expected data for a given test.  Do this when
# you've (intentionally!) introduced changes to the expected behavior
# of this package and want to update the tests to check for the new
# behavior.
update-%: clean
	mkdir -p test-output
	$(call do-tests,$(subst update-,,$@))
	rm -rf tdata/$(subst update-,,$@)
	mv test-output tdata/$(subst update-,,$@) 

.PHONY: test
test: ${TESTS}

.PHONY: clean
clean:
	rm -rf test-output

