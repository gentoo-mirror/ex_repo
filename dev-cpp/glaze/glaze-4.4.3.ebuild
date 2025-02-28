# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Extremely fast, in memory, JSON and interface library for modern C++ "
HOMEPAGE="https://github.com/stephenberry/glaze"
SRC_URI="https://github.com/stephenberry/glaze/archive/refs/tags/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

IUSE="
	test
	fuzzing
	examples
	doc
"

REQUIRED_USE="
"

DEPEND="
	test? ( dev-cpp/ut2-glaze dev-cpp/asio )
"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-build/cmake
"

RESTRICT="
"

PATCHES=(
	"${FILESDIR}/0000_fix_bundling_ut2-glaze.patch"
	"${FILESDIR}/0001_fix_bundling_asio.patch"
)

S="${WORKDIR}/glaze-${PV}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RULES=OFF
		-Dglaze_DEVELOPER_MODE=ON
		-Dglaze_ENABLE_FUZZING=$(usex fuzzing ON OFF)
		-Dglaze_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DBUILD_TESTING=$(usex test ON OFF)

		# my default:
		-DFETCHCONTENT_QUIET=OFF
		--log-level=DEBUG
	)

	cmake-multilib_src_configure

}

src_install() {
	if use doc; then
		einstalldocs
	fi

	cmake-multilib_src_install
}
