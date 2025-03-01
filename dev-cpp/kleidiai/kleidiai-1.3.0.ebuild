# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Computational micro-kernels for Arm® CPUs. AI-related."
HOMEPAGE="https://gitlab.arm.com/kleidi/kleidiai"
SRC_URI="https://gitlab.arm.com/kleidi/kleidiai/-/archive/v${PV}/kleidiai-v${PV}.tar.bz2"

S="${WORKDIR}/kleidiai-v${PV}"

LICENSE="Apache-2.0 BSD"
SLOT="0"

KEYWORDS="~arm ~arm64 ~arm64-macos"

IUSE="
	test
	benchmark
	clang-tidy
"

# REQUIRED_USE=""

DEPEND="
	test? ( >=dev-cpp/gtest-1.14.0 )
	benchmark? ( >=dev-cpp/benchmark-1.8.4 )
"

RDEPEND="${DEPEND}"

BDEPEND="
	clang-tidy? ( llvm-core/clang[extra] )
"

# RESTRICT=""

PATCHES=(
	"${FILESDIR}/0004_make_it_use_installed_gtest_and_google_benchmark_and_make_it_install_the_project.patch"
)

src_configure() {
	local mycmakeargs=(
		-DKLEIDIAI_BUILD_TESTS=$(usex test ON OFF)
		-DKLEIDIAI_BUILD_BENCHMARK=$(usex benchmark ON OFF)
		-DKLEIDIAI_ENABLE_CLANG_TIDY=$(usex clang-tidy ON OFF)

		# my default:
		-DFETCHCONTENT_QUIET=OFF
		--log-level=DEBUG
	)

	cmake-multilib_src_configure

}
