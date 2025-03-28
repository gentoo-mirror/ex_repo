# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="C library that may be linked into a C/C++ program to produce symbolic backtraces"
HOMEPAGE="https://github.com/ianlancetaylor/libbacktrace"

COMMITHASH="0034e33946824057b48c5e686a3aefc761b37384"

SRC_URI="${HOMEPAGE}/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMITHASH}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc64 ~riscv ~x86"
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

src_configure() {
	# tests are failing with LTO.
	# https://github.com/ianlancetaylor/libbacktrace/issues/152
	filter-lto
	econf --enable-shared \
		$(use_enable static{-libs,})
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
