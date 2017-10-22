#$OpenBSD$
ONLY_FOR_ARCHS =	amd64
COMMENT =		client for orchestrating remote and local Docker hosts

DISTNAME =		v0.13.0
PKGNAME =		docker-machine-0.13.0

GH_ACCOUNT =		docker
GH_PROJECT =		machine
GH_TAGNAME =		v0.13.0

CATEGORIES =		sysutils
HOMEPAGE =		https://docs.docker.com/machine/
MAINTAINER =		Dave Voutila <dave@sisu.io>

# APL v2.0
PERMIT_PACKAGE_CDROM =	Yes

WANTLIB +=		c pthread

MASTER_SITES =		https://github.com/docker/machine/archive/

MODULES =		lang/go
BUILD_DEPENDS =	 	devel/gmake
MODGO_TYPE =		bin

# machine's include Makefile needs to be told to use our Go command
MAKE_FLAGS +=		GO="${MODGO_CMD}"

do-build:
	@cp ${FILESDIR}/termios_openbsd.go \
        	${WRKSRC}/vendor/github.com/docker/docker/pkg/term
	@cp ${FILESDIR}/os_openbsd.go ${WRKSRC}/libmachine/crashreport
	@cp ${FILESDIR}/virtualbox_openbsd.go ${WRKSRC}/drivers/virtualbox
	cd ${WRKSRC} && gmake build ${MAKE_FLAGS}

do-test:
	cd ${WRKSRC} && \
        	${MODGO_CMD} get -u "github.com/golang/lint/golint" && \
		gmake test GO="${MODGO_CMD}" GOLINT_BIN=${WRKDIR}/go/bin/golint

do-install:
	echo "installing? ---???"
	${INSTALL_PROGRAM} ${WRKSRC}/bin/docker-machine ${PREFIX}/bin

.include <bsd.port.mk>
