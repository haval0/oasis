cflags{
	'-Wall', '-Wextra', '-Wpedantic',
	'-D ZSTD_LEGACY_SUPPORT=0',
	'-D ZSTD_NO_UNUSED_FUNCTIONS',
	'-D ZSTD_MULTITHREAD',
	'-D XXH_NAMESPACE=ZSTD_',
	'-D ZSTD_NOBENCH',
	'-D ZSTD_NODICT',
	'-D ZSTD_NOTRACE',
	'-D ZSTD_TRACE=0',
}

pkg.hdrs = {
	copy('$outdir/include', '$srcdir/lib', {'zstd.h'}),
	copy('$outdir/include', '$srcdir/lib/common', {'zstd_errors.h'}),
	copy('$outdir/include', '$srcdir/lib/dictBuilder', {'zdict.h'}),
}
pkg.deps = {
	'$gendir/headers',
}

lib('libzstd.a', [[lib/(
	common/(
		debug.c
		entropy_common.c
		error_private.c
		fse_decompress.c
		pool.c
		threading.c
		xxhash.c
		zstd_common.c
	)
	compress/(
		fse_compress.c
		hist.c
		huf_compress.c
		zstd_compress.c
		zstd_compress_literals.c
		zstd_compress_sequences.c
		zstd_compress_superblock.c
		zstd_double_fast.c
		zstd_fast.c
		zstd_lazy.c
		zstd_ldm.c
		zstd_opt.c
		zstdmt_compress.c
	)
	decompress/(
		huf_decompress.c
		zstd_ddict.c
		zstd_decompress.c
		zstd_decompress_block.c
	)
)]])

exe('zstd', [[
	programs/(zstdcli.c util.c timefn.c fileio.c)
	libzstd.a
]])
file('bin/zstd', '755', '$outdir/zstd')
sym('bin/unzstd', 'zstd')
sym('bin/zstdcat', 'zstd')

man{'programs/zstd.1'}

fetch 'git'
