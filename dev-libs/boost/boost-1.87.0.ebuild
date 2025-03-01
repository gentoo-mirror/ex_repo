# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Famous Boost libraries for C++, but built via CMake, not b2"
HOMEPAGE="https://www.boost.org/"
SRC_URI="https://github.com/boostorg/boost/releases/download/boost-${PV}/boost-${PV}-cmake.tar.xz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="mpi +python static +boost-context-fcontext boost-context-ucontext boost-context-winfib +boost-locale-icu boost-locale-iconv boost-locale-posix boost-locale-std boost-locale-winapi +boost-thread-pthread boost-thread-win32 +boost-iostream-zlib +boost-iostream-bzip2 +boost-iostream-lzma +boost-iostream-zstd"

REQUIRED_USE="
	^^ ( boost-context-fcontext boost-context-ucontext boost-context-winfib )
	^^ ( boost-locale-icu boost-locale-iconv boost-locale-posix boost-locale-std boost-locale-winapi )
	boost-locale-winapi? ( static )
	^^ ( boost-thread-pthread boost-thread-win32 )
"

DEPEND="
	boost-locale-icu? ( dev-libs/icu:=[${MULTILIB_USEDEP}] )
	boost-locale-iconv? ( virtual/libiconv[${MULTILIB_USEDEP}] )
	boost-iostream-zlib? ( sys-libs/zlib:=[${MULTILIB_USEDEP}] )
	boost-iostream-bzip2? ( app-arch/bzip2:=[${MULTILIB_USEDEP}] )
	boost-iostream-lzma? ( app-arch/xz-utils:=[${MULTILIB_USEDEP}] )
	boost-iostream-zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"

RDEPEND="${DEPEND}"

BDEPEND="
dev-build/cmake
"

PATCHES=(
	"${FILESDIR}/0000_boost-1.87.0_iostreams_pkgconfig.patch"
)

src_configure() {
		# Gentoo users enable ccache via e.g. FEATURES=ccache or
	# other means. We don't want the build system to enable it for us.
	sed -i -e '/find_program(CCACHE_FOUND ccache)/d' CMakeLists.txt || die

	local mycmakeargs=(
		-DBOOST_ENABLE_MPI=$(usex mpi ON OFF)
		-DBOOST_ENABLE_PYTHON=$(usex python ON OFF)
		-DBUILD_SHARED_LIBS=$(usex static true false)
		-DBOOST_IOSTREAMS_ENABLE_ZLIB=$(usex boost-iostream-zlib ON OFF)
		-DBOOST_IOSTREAMS_ENABLE_BZIP2=$(usex boost-iostream-bzip2 ON OFF)
		-DBOOST_IOSTREAMS_ENABLE_LZMA=$(usex boost-iostream-lzma ON OFF)
		-DBOOST_IOSTREAMS_ENABLE_ZSTD=$(usex boost-iostream-zstd ON OFF)
	)

	if use boost-context-fcontext; then
		mycmakeargs+=( -DBOOST_CONTEXT_IMPLEMENTATION=fcontext )
	elif use boost-context-ucontext; then
		mycmakeargs+=( -DBOOST_CONTEXT_IMPLEMENTATION=ucontext )
	else
		mycmakeargs+=( -DBOOST_CONTEXT_IMPLEMENTATION=winfib )
	fi

	if use boost-locale-icu; then
		mycmakeargs+=( -DBOOST_LOCALE_ENABLE_ICU=ON )
	elif use boost-locale-iconv; then
		mycmakeargs+=( -DBOOST_LOCALE_ENABLE_ICONV=ON )
	elif use boost-locale-posix; then
		mycmakeargs+=( -DBOOST_LOCALE_ENABLE_POSIX=ON )
	elif use boost-locale-std; then
		mycmakeargs+=( -DBOOST_LOCALE_ENABLE_STD=ON )
	else
		mycmakeargs+=( -DBOOST_LOCALE_ENABLE_WINAPI=ON )
	fi

	if use boost-thread-pthread; then
		mycmakeargs+=( -DBOOST_THREAD_THREADAPI=pthread )
	else
		mycmakeargs+=( -DBOOST_THREAD_THREADAPI=win32 )
	fi

	cmake-multilib_src_configure

}
