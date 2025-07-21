# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# it's a header-only lib, thus not cmake-multilib. However, examples and tests...
inherit cmake

DESCRIPTION="Professionally written C++ function traits library (single header-only) for retrieving info about any function (arg types, arg count, return type, etc.)"
HOMEPAGE="https://github.com/HexadigmSystems/FunctionTraits"

COMMIT="d4a6f8a96df2d8174219dc0a73f0201193b3c538"

SRC_URI="
https://github.com/HexadigmSystems/FunctionTraits/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/FunctionTraits-${COMMIT}"

LICENSE="Hexadigm_Generic_C++_library"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
# IUSE=""

# REQUIRED_USE=""

# RESTRICT=""

# PROPERTIES=""

# DEPEND=""

# RDEPEND="${DEPEND}"

BDEPEND="
dev-build/cmake
"

PATCHES=(
	"${FILESDIR}/0000_basic_CMakeLists.txt_.patch"
)
