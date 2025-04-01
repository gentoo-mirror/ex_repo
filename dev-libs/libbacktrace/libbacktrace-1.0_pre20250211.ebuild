# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal flag-o-matic

DESCRIPTION="C library that may be linked into a C/C++ program to produce symbolic backtraces"
HOMEPAGE="https://github.com/ianlancetaylor/libbacktrace"

COMMITHASH="0034e33946824057b48c5e686a3aefc761b37384"

SRC_URI="https://github.com/ianlancetaylor/libbacktrace/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMITHASH}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-arch/xz-utils
		sys-libs/zlib
	)
"

src_prepare() {
	default

	eautoreconf
}

multilib_src_configure() {

	# tests are failing with LTO.
	# https://github.com/ianlancetaylor/libbacktrace/issues/152
	filter-lto

	ECONF_SOURCE="${S}" econf --enable-shared \
		$(use_enable static{-libs,})
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
