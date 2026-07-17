local({
	if (!nzchar(Sys.which("rv"))) {
		warning(
			"rv is not installed! Install rv, then restart your R session",
			call. = FALSE
		)
		return()
	}
	rv_info <- system2(
		"rv",
		c("info", "--library", "--r-version", "--repositories"),
		stdout = TRUE
	)
	if (!is.null(attr(rv_info, "status"))) {
		# if system2 fails it'll add a status attribute with the error code
		warning("failed to run rv info, check your console for messages")
		return()
	}
	get_val <- function(prefix) {
		line <- grep(paste0("^", prefix, ":"), rv_info, value = TRUE)
		sub(paste0("^", prefix, ":\\s*"), "", line)
	}

	# Set repos option
	repo_str <- get_val("repositories")

	repo_parts <- strsplit(repo_str, "), ", fixed = TRUE)[[1]]
	repo_parts <- gsub("[()]", "", repo_parts)

	repo_urls <- character(length(repo_parts))
	repo_names <- character(length(repo_parts))

	for (i in seq_along(repo_parts)) {
		parts <- strsplit(repo_parts[i], ",", fixed = TRUE)[[1]]
		repo_names[i] <- trimws(parts[1])
		repo_urls[i] <- trimws(parts[2])
	}
	names(repo_urls) <- repo_names
	options(repos = repo_urls)

	# Check R version and set library
	rv_r_ver <- get_val("r-version")
	sys_r <- sprintf("%s.%s", R.version$major, R.version$minor)
	r_match <- grepl(paste0("^", rv_r_ver), sys_r)

	rv_lib <- if (r_match) {
		normalizePath(get_val("library"), mustWork = FALSE)
	} else {
		message(sprintf(
			"WARNING: R version specified in config (%s) does not match session version (%s).
rv library will not be activated until the issue is resolved. Entering safe mode...
			",
			rv_r_ver,
			sys_r
		))
		file.path(tempdir(), "__rv_R_mismatch")
	}

	if (!dir.exists(rv_lib)) {
		if (r_match) {
			message("creating rv library: ", rv_lib, "\n")
		} else {
			message("creating temporary library: ", rv_lib, "\n")
		}
		dir.create(rv_lib, recursive = TRUE)
	}

	.libPaths(rv_lib, include.site = FALSE)
	Sys.setenv("R_LIBS_USER" = rv_lib)
	Sys.setenv("R_LIBS_SITE" = rv_lib)

	# Results
	if (interactive()) {
		message(
			"rv repositories active!\nrepositories: \n",
			paste0(
				"  ",
				names(getOption("repos")),
				": ",
				getOption("repos"),
				collapse = "\n"
			),
			"\n"
		)
		message(
			if (r_match) {
				"rv libpaths active!\nlibrary paths: \n"
			} else {
				"rv libpaths are not active due to R version mismatch. Using temp directory: \n"
			},
			paste0("  ", .libPaths(), collapse = "\n")
		)
	}
})
