.rv <- new.env()
.rv$config_path <- file.path(normalizePath(getwd()), "rproject.toml")
.rv$summary <- function(json = FALSE) {
  command <- c("summary")
  if (json) { command <- c(command, "--json") }
  .rv$command(command)
}
.rv$plan <- function() { .rv$command("plan") }
.rv$sync <- function() { .rv$command("sync") }
.rv$add <- function(..., dry_run = FALSE) {
  dots <- unlist(list(...))
  command <- c("add", dots)
  if (dry_run) { command <- c(command, "--dry-run") }
  .rv$command(command)
}

.rv$command <- function(command) {
  # underlying system calls to rv
  args <- c(command, "-c", .rv$config_path)
  res <- system2("rv", args, stdout = TRUE)
  if (!is.null(attr(res, "status"))) {
    warning(sprintf("failed to run `rv %s`, check your console for messages", paste(args, collapse = " ")))
  } else {
    message(paste(res, collapse = "\n"))
  }
}