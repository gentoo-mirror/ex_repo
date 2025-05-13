# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Lightweight structured concurrency for C++20"
HOMEPAGE="https://github.com/hudson-trading/corral"

CORRAL_COMMIT="f1fc7ab37f9b0f4a8d4d611d15f92f1e89bebd27"

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
	"${FILESDIR}/0000_make_tests_be_buildable_only_when_BUILD_TESTING_is_enabled.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RULES=OFF
		-DBUILD_TESTING=$(usex test ON OFF)
		-DCORRAL_CATCH2=""
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
