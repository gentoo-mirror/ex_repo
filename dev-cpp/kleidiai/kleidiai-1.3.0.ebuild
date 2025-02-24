# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="KleidiAI is an open-source library that provides optimized performance-critical routines, also known as micro-kernels, for artificial intelligence (AI) workloads tailored for Arm® CPUs."
HOMEPAGE="https://gitlab.arm.com/kleidi/kleidiai"
SRC_URI="https://gitlab.arm.com/kleidi/kleidiai/-/archive/v${PV}/kleidiai-v${PV}.tar.gz"

LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

IUSE="
	test
	benchmark
	clang-tidy
"

REQUIRED_USE="
"

DEPEND="
	test? ( >=dev-cpp/gtest-1.14.0 )
	benchmark? ( >=dev-cpp/benchmark-1.8.4 )
"

RDEPEND="${DEPEND}"

BDEPEND="
 	clang-tidy? ( llvm-core/clang[extra] )
"

RESTRICT="
"

PATCHES=(
	"${FILESDIR}/0000_fix_bundling_dependencies.patch"
	"${FILESDIR}/0001_install_it.patch"
)

S="${WORKDIR}/kleidiai-v${PV}"

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
