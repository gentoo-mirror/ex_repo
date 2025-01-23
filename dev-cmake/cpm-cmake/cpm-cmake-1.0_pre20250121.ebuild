# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A cmake not package manager. Essentially, it's about 'how to do bundled dependencies better', though it sucks when you have anything remotely complex. Arniiiii's fork. Don't use CPM in your projects. I've used it and now regret about it. https://michael.orlitzky.com/articles/motherfuckers_need_package_management.xhtml"
HOMEPAGE="https://github.com/Arniiiii/CPM.cmake"

CPM_CMAKE_COMMIT="4d245d2e584298071e5f7723fc8fc6f02f79f9b5"

SRC_URI="https://github.com/Arniiiii/CPM.cmake/archive/${CPM_CMAKE_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc"

REQUIRED_USE="
"

DEPEND="
"

RDEPEND="${DEPEND}"

BDEPEND="
dev-build/cmake
"

S="${WORKDIR}/CPM.cmake-${CPM_CMAKE_COMMIT}"

src_install() {
	insinto /usr/share/cmake
	doins ${S}/cmake/CPM.cmake

	if use doc; then
		einstalldocs
	fi
}
