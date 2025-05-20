# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Lightweight structured concurrency for C++20"
HOMEPAGE="https://github.com/hudson-trading/corral"

CORRAL_COMMIT="e1c63b1249580fad2e0f526bb375c7dd74c7046d"

SRC_URI="https://github.com/hudson-trading/corral/archive/${CORRAL_COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/corral-${CORRAL_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris" # no mips s390 because of dev-cpp/asio::gentoo .

IUSE="
	test
	examples
	doc
"

RESTRICT="!test? ( test )"

# REQUIRED_USE=""

DEPEND="
	test? (
		dev-libs/boost
		dev-cpp/catch
		dev-libs/openssl
	)
	examples? (
		dev-libs/boost
		dev-qt/qtbase
)
"

# RDEPEND="${DEPEND}"

# BDEPEND="
# "

# RESTRICT=""

PATCHES=(
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RULES=OFF
		-DBUILD_TESTING=$(usex test ON OFF)
		-DCORRAL_CATCH2=""
		-DCORRAL_BOOST="a" # here can be anything not same as ".*://.*"
		-DCORRAL_EXAMPLES=$(usex examples ON OFF)

		# my default:
		-DFETCHCONTENT_QUIET=OFF
		--log-level=DEBUG
	)

	cmake_src_configure

}

src_install() {
	if use doc; then
		einstalldocs
	fi

	cmake_src_install
}
