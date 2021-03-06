# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the MIT License. See the LICENSE accompanying this file
# for the specific language governing permissions and limitations under
# the License.
#
# This file provides a common interface to execute the various tests.

export TESTDIR?=${CURDIR}
OUTPUTDIR=${TESTDIR}/test-output
TESTS=eth0-basic secondary-basic secondary-more-ips
SCRIPTS=ec2ifup ec2dhcp.sh ec2ifdown
CLEANFILES+=${OUTPUTDIR}

define do-tests
 $(foreach t,${SCRIPTS},
   $(call do-test,${1},${t})
  )
endef

define do-test
  cd ${TESTDIR} && \
    PARAMS=${TESTDIR}/params-${1}.sh \
    ETCDIR="./test-output/${1}/etc" \
    ./test-${2} 2> ${OUTPUTDIR}/${1}/${2}.out
endef

define compare-outputs
  $(foreach t,${SCRIPTS},
    $(call compare-output,${1},${t})
  )
endef

define compare-output
  diff -u ${TESTDIR}/tdata/${1}/${2}.out ${OUTPUTDIR}/${1}/${2}.out
endef

.PHONY: test-%
test-%:
	@mkdir -p ${OUTPUTDIR}/${@:test-%=%}
	$(call do-tests,$(subst test-,,$@))
	$(call compare-outputs,$(subst test-,,$@))

# Use this to update the expected data for a given test.  Do this when
# you've (intentionally!) introduced changes to the expected behavior
# of this package and want to update the tests to check for the new
# behavior.
.PHONY: update-%
update-%:
	-rm -rf ${OUTPUTDIR}/${@:update-%=%}
	mkdir -p ${OUTPUTDIR}/${@:update-%=%}
	$(call do-tests,$(subst update-,,$@))
	rm -rf ${TESTDIR}/tdata/$(subst update-,,$@)
	mv ${OUTPUTDIR}/${@:update-%=%} ${TESTDIR}/tdata/${@:update-%=%}

.PHONY: test
test: $(TESTS:%=test-%)
