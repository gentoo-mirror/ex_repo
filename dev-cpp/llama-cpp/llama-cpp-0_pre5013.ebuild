# Coqyright 2025 Arniiiii lg3dx6fd@gmail.com and wadewilson619 at discord
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=6.3

inherit cmake-multilib cuda rocm

DESCRIPTION="Inference of Meta's LLaMA model (and others) in pure C/C++"
HOMEPAGE="https://github.com/ggerganov/llama.cpp"

MY_PV="b${PV#0_pre}"

SRC_URI="https://github.com/ggerganov/llama.cpp/archive/refs/tags/${MY_PV}.tar.gz -> llama.cpp-${MY_PV}.tar.gz"

S="${WORKDIR}/llama.cpp-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~arm64-macos ~loong ~riscv ~x64-macos ~x86 ~x86-macos"

# CPU_FLAGS_x86_fma doesn't exist, thus place everything here.
IUSE="
static
lto
test
examples
+server

curl

hbm

android
msvc

+accelerate

blas

blis

+llamafile

cann

musa

cuda
cuda-force-mmq
cuda-force-cublas
+cuda-unified-memory
cuda-f16
cuda-no-peer-copy
cuda-no-vmm
cuda-fa-all-quants
+cuda-graphs

hip
hip-graphs
+hip-no-vmm
hip-uma

vulkan
vulkan-check-results
vulkan-debug
vulkan-memory-debug
vulkan-shader-debug-info
vulkan-perf
vulkan-validate
vulkan-run-tests

kompute

+openmp

rpc

opencl
opencl-profiling
+opencl-embed-kernels
+opencl-use-adreno-kernels

metal
metal-use-bf16
metal-ndebug
metal-shader-debug
+metal-embed-library

+cpu

cpu-native

cpu_flags_x86_avx
cpu_flags_x86_avx_vnni
cpu_flags_x86_avx2
cpu_flags_x86_avx512
cpu_flags_x86_avx512_vbmi
cpu_flags_x86_avx512_vnni
cpu_flags_x86_avx512_bf16
cpu_flags_x86_fma
cpu_flags_x86_f16c
cpu_flags_x86_amx_tile
cpu_flags_x86_amx_int8
cpu_flags_x86_amx_bf16
cpu_flags_x86_sse
cpu_flags_x86_sse2
cpu_flags_x86_sse3
cpu_flags_x86_sse4
cpu_flags_x86_sse4a
cpu_flags_x86_sse41
cpu_flags_x86_sse42
cpu_flags_x86_ssse3

kleidiai

cpu_flags_loong_lasx
cpu_flags_loong_lsx

cpu_flags_riscv_rvv
"

# since this is too hard to do right now
# sycl
# sycl-f16
# sycl-target-nvidia
# sycl-target-amdgpu
# sycl-target-intelgpu
# sycl-via-openapi
# sycl-via-opemkl
# "

# in MSVC F16C and FMA is implied with AVX2/AVX512
# MSVC does not seem to support AMX
# android stuff added according to their docs.
# a lot of !flag ( !subflags ) statements placed for binpkg correctness
REQUIRED_USE="
	test? ( curl )
	vulkan-run-tests? ( test )
	blis? ( blas )
	android? (
		!llamafile
		!openmp
	)
	msvc? (
		!cpu_flags_x86_fma
		!cpu_flags_x86_f16c
		!cpu_flags_x86_amx_tile
		!cpu_flags_x86_amx_int8
		!cpu_flags_x86_amx_bf16
	)
	!cuda? (
		!cuda-force-mmq
		!cuda-force-cublas
		!cuda-unified-memory
		!cuda-f16
		!cuda-no-peer-copy
		!cuda-no-vmm
		!cuda-fa-all-quants
		!cuda-graphs
	)
	!hip? (
		!hip-graphs
		!hip-no-vmm
		!hip-uma
	)
	!vulkan? (
		!vulkan-check-results
		!vulkan-debug
		!vulkan-memory-debug
		!vulkan-shader-debug-info
		!vulkan-perf
		!vulkan-validate
		!vulkan-run-tests
	)
	!opencl? (
		!opencl-profiling
		!opencl-embed-kernels
		!opencl-use-adreno-kernels
	)
	!cpu? (
		!cpu_flags_x86_avx
		!cpu_flags_x86_avx_vnni
		!cpu_flags_x86_avx2
		!cpu_flags_x86_avx512
		!cpu_flags_x86_avx512_vbmi
		!cpu_flags_x86_avx512_vnni
		!cpu_flags_x86_avx512_bf16
		!cpu_flags_x86_fma
		!cpu_flags_x86_f16c
		!cpu_flags_x86_amx_tile
		!cpu_flags_x86_amx_int8
		!cpu_flags_x86_amx_bf16
		!cpu_flags_x86_sse
		!cpu_flags_x86_sse2
		!cpu_flags_x86_sse3
		!cpu_flags_x86_sse4
		!cpu_flags_x86_sse4a
		!cpu_flags_x86_sse41
		!cpu_flags_x86_sse42
		!cpu_flags_x86_ssse3

		!cpu_flags_loong_lasx
		!cpu_flags_loong_lsx

		!cpu_flags_riscv_rvv
	)
"

DEPEND="
	blas? ( virtual/blas )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	blis? ( sci-libs/blis )
	opencl? ( virtual/opencl )
	kleidiai? ( dev-cpp/kleidiai )
"
# since this is too hard right now.
# 	sycl-target-nvidia? ( dev-util/nvidia-cuda-toolkit )
# 	sycl-target-amdgpu? ( dev-util/nvidia-cuda-toolkit )
# 	sycl-target-intelgpu? ( dev-util/nvidia-cuda-toolkit )
# "

RDEPEND="
	blas? ( virtual/blas )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	blis? ( sci-libs/blis )
	opencl? ( virtual/opencl )
"

BDEPEND="
"

PATCHES=(
	"${FILESDIR}/0001_GGML_CANN_option_has_to_do_something.patch"
	"${FILESDIR}/0002_add_sse_flags_ver2.patch"
	"${FILESDIR}/0003_fix_bundling_kleidiai_ver2.patch"
	"${FILESDIR}/0004_fix_test_chat.patch"
)

RESTRICT="!test? ( test ) test? ( userpriv )"

src_prepare() {
	if use cuda; then
		cuda_src_prepare
	fi
	cmake_src_prepare
}

src_configure() {
	if use hip; then
		HIPCC=$(hipconfig -l)/clang
		HIPCXX=$(hipconfig -l)/clang++
		# export DEVICE_LIB_PATH=${EPREFIX}/usr/lib/amdgcn/bitcode # not sure what to do with that
		HIP_PATH=$(hipconfig -R)
	fi

	local mycmakeargs=(
		-DGGML_LTO=$(usex lto ON OFF)

		# add these via user's /etc/portage/make.conf as i.e.`-fsanitize=address`
		-DLLAMA_SANITIZE_THREAD=OFF
		-DLLAMA_SANITIZE_ADDRESS=OFF
		-DLLAMA_SANITIZE_UNDEFINED=OFF

		-DLLAMA_CURL=$(usex curl ON OFF)

		-DLLAMA_BUILD_TESTS=$(usex test ON OFF)
		-DLLAMA_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DLLAMA_BUILD_SERVER=$(usex server ON OFF)
		-DLLAMA_BUILD_COMMON=ON
		# -DLLAMA_BUILD_SERVER=OFF # why
		# -DCMAKE_SKIP_BUILD_RPATH=ON # why?
		-DBUILD_NUMBER="${MY_PV}"
		# -DCMAKE_INSTALL_PREFIX=${EPREFIX}/opt/${PN} # why would you need that?
		# -DCMAKE_CUDA_ARCHITECTURES="75" # I guess this should be set by user.

		-DBUILD_SHARED_LIBS=$(usex static OFF ON)

		-DGGML_CPU=$(usex cpu ON OFF)

		-DGGML_NATIVE=$(usex cpu-native ON OFF)

		-DGGML_CPU_AARCH64=$(usex arm64 ON OFF)
		-DGGML_CPU_HBM=$(usex hbm ON OFF)
		-DGGML_CPU_KLEIDIAI=$(usex kleidiai ON OFF)
		-DGGML_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DGGML_AVX_VNNI=$(usex cpu_flags_x86_avx_vnni ON OFF)
		-DGGML_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)
		-DGGML_AVX512=$(usex cpu_flags_x86_avx512 ON OFF)
		-DGGML_AVX512_VBMI=$(usex cpu_flags_x86_avx512_vbmi ON OFF)
		-DGGML_AVX512_VNNI=$(usex cpu_flags_x86_avx512_vnni ON OFF)
		-DGGML_AVX512_BF16=$(usex cpu_flags_x86_avx512_bf16 ON OFF)
		-DGGML_FMA=$(usex cpu_flags_x86_fma ON OFF)
		-DGGML_F16C=$(usex cpu_flags_x86_f16c ON OFF)
		-DGGML_AMX_TILE=$(usex cpu_flags_x86_amx_tile ON OFF)
		-DGGML_AMX_INT8=$(usex cpu_flags_x86_amx_int8 ON OFF)
		-DGGML_AMX_BF16=$(usex cpu_flags_x86_amx_bf16 ON OFF)
		-DGGML_SSE=$(usex cpu_flags_x86_sse ON OFF)
		-DGGML_SSE2=$(usex cpu_flags_x86_sse2 ON OFF)
		-DGGML_SSE3=$(usex cpu_flags_x86_sse3 ON OFF)
		-DGGML_SSE4=$(usex cpu_flags_x86_sse4 ON OFF)
		-DGGML_SSE4A=$(usex cpu_flags_x86_sse4a ON OFF)
		-DGGML_SSE41=$(usex cpu_flags_x86_sse41 ON OFF)
		-DGGML_SSE42=$(usex cpu_flags_x86_sse42 ON OFF)
		-DGGML_SSSE3=$(usex cpu_flags_x86_ssse3 ON OFF)
		-DGGML_LASX=$(usex cpu_flags_loong_lasx ON OFF)
		-DGGML_LSX=$(usex cpu_flags_loong_lsx ON OFF)
		-DGGML_RVV=$(usex cpu_flags_riscv_rvv ON OFF)

		-DGGML_ACCELERATE=$(usex accelerate ON OFF)

		-DGGML_BLAS=$(usex blas ON OFF)

		-DGGML_CANN=$(usex cann ON OFF)

		-DGGML_LLAMAFILE=$(usex llamafile ON OFF)

		-DGGML_MUSA=$(usex musa ON OFF)

		-DGGML_CUDA=$(usex cuda ON OFF)
		-DGGML_CUDA_FORCE_MMQ=$(usex cuda-force-mmq ON OFF)
		-DGGML_CUDA_FORCE_CUBLAS=$(usex cuda-force-cublas ON OFF)
		-DGGML_CUDA_F16=$(usex cuda-f16 ON OFF)
		-DGGML_CUDA_NO_PEER_COPY=$(usex cuda-no-peer-copy ON OFF)
		-DGGML_CUDA_NO_VMM=$(usex cuda-no-vmm ON OFF)
		-DGGML_CUDA_FA_ALL_QUANTS=$(usex cuda-fa-all-quants ON OFF)
		-DGGML_CUDA_GRAPHS=$(usex cuda-graphs ON OFF)
		# CPU+GPU Unified Memory
		-DGGML_CUDA_ENABLE_UNIFIED_MEMORY=$(usex cuda-unified-memory 1 0)

		-DGGML_HIP=$(usex hip ON OFF)
		-DGGML_HIP_GRAPHS=$(usex hip-graphs ON OFF)
		-DGGML_HIP_NO_VMM=$(usex hip-no-vmm ON OFF)
		-DGGML_HIP_UMA=$(usex hip-uma ON OFF)

		-DGGML_VULKAN=$(usex vulkan ON OFF)
		-DGGML_VULKAN_CHECK_RESULTS=$(usex vulkan-check-results ON OFF)
		-DGGML_VULKAN_DEBUG=$(usex vulkan-debug ON OFF)
		-DGGML_VULKAN_MEMORY_DEBUG=$(usex vulkan-memory-debug ON OFF)
		-DGGML_VULKAN_SHADER_DEBUG_INFO=$(usex vulkan-shader-debug-info ON OFF)
		-DGGML_VULKAN_PERF=$(usex vulkan-perf ON OFF)
		-DGGML_VULKAN_VALIDATE=$(usex vulkan-validate ON OFF)
		-DGGML_VULKAN_RUN_TESTS=$(usex vulkan-run-tests ON OFF)

		-DGGML_KOMPUTE=$(usex kompute ON OFF)

		-DGGML_METAL=$(usex metal ON OFF)
		-DGGML_METAL_USE_BF16=$(usex metal-use-bf16 ON OFF)
		-DGGML_METAL_NDEBUG=$(usex metal-ndebug ON OFF)
		-DGGML_METAL_SHADER_DEBUG=$(usex metal-shader-debug ON OFF)
		-DGGML_METAL_EMBED_LIBRARY=$(usex metal-embed-library ON OFF)

		-DGGML_OPENMP=$(usex openmp ON OFF)

		-DGGML_RPC=$(usex rpc ON OFF)

		-DGGML_SYCL=OFF
		# -DGGML_SYCL=$(usex sycl ON OFF)
		# -DGGML_SYCL_F16=$(usex sycl-f16 ON OFF)

		-DGGML_OPENCL=$(usex opencl ON OFF)
		-DGGML_OPENCL_PROFILING=$(usex opencl-profiling ON OFF)
		-DGGML_OPENCL_EMBED_KERNELS=$(usex opencl-embed-kernels ON OFF)
		-DGGML_OPENCL_USE_ADRENO_KERNELS=$(usex opencl-use-adreno-kernels ON OFF)

		# -DGGML_BUILD_TESTS=$(usex test ON OFF) # broken option
		# -DGGML_BUILD_EXAMPLES=$(usex examples ON OFF) # broken option

		# Gentoo users enable ccache via e.g. FEATURES=ccache or
		# other means. We don't want the build system to enable it for us.
		-DGGML_CCACHE=OFF

		# defaults aren't so good
		--log-level=DEBUG
		-DFETCHCONTENT_QUIET=OFF
	)

	if use blis; then
		mycmakeargs+=( -DGGML_BLAD_VENDOR=FLAME )
	fi

	if use hip; then
		mycmakeargs+=( -DAMDGPU_TARGETS=$(get_amdgpu_flags) )
	fi

	cmake-multilib_src_configure
}

src_test() {
	if use cuda; then
		addpredict /dev/nvidiactl

		# we need write access to this to run the tests
		addwrite /dev/nvidia0
		addwrite /dev/nvidiactl
		addwrite /dev/nvidia-uvm
		addwrite /dev/nvidia-uvm-tools
		cuda_add_sandbox
	fi

	if use hip; then
		check_amdgpu
	fi
	# cd "${BUILD_DIR}" || die # why this exists?
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"${BUILD_DIR}/bin"
	cmake-multilib_src_test
}
