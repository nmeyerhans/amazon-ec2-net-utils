pkgname=amazon-ec2-net-utils
version=1.5

DESTDIR=/
prefix=${DESTDIR}/usr/local
sysconfdir=${DESTDIR}/etc
sbindir=${DESTDIR}/${prefix}/sbin
systemddir=${DESTDIR}/${prefix}/lib/systemd
udevdir=${DESTDIR}/${prefix}/lib/udev
mandir=${DESTDIR}/${prefix}/share/man

define install-file
install -o root -g root -m644 $1 $2
endef

define install-exe
install -o root -g root -m755 $1 $2
endef

sources:
	git archive --prefix ${pkgname}-${version}/ HEAD | gzip --best > ../${pkgname}-${version}.tar.gz

test:
	${MAKE} -C tests test

install:
	${call install-file,ec2dhcp.sh,${sysconfdir}/dhcp/dhclient.d}
	${call install-file,ixgbevf.conf,${sysconfdir}/modprobe.d}
	${call install-file,ec2net-functions,${sysconfdir}/sysconfig/network-scripts}
	${call install-file,ec2net.hotplug,${sysconfdir}/sysconfig/network-scripts}
	${call install-file,53-ec2-network-interfaces.rules,${sysconfdir}/udev/rules.d}
	${call install-file,75-persistent-net-generator.rules,${sysconfdir}/udev/rules.d}
	${call install-file,ec2net-ifup@.service,${systemddir}/system}
	${call install-file,ec2net-scan.service,${systemddir}/system}
	${call install-file,rule_generator.functions,${udevdir}}
	${call install-file,write_net_rules,${udevdir}}
	${call install-exe,ec2ifdown,${sbindir}}
	${call install-exe,ec2ifscan,${sbindir}}
	${call install-exe,ec2ifup,${sbindir}}
	${call install-file,ec2ifdown.8.gz,${mandir}/man8}
	${call install-file,ec2ifscan.8.gz,${mandir}/man8}
	${call install-file,ec2ifup.8.gz,${mandir}/man8}
