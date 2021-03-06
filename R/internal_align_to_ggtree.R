
#' align a matrix to a ggtree
#'
#' It matches rows of a matrix to nodes of a ggtree by the row name.
#'
#' @param data a matrix. Its row names can be mapped to nodes of a tree.
#' @param data_tree a data frame that is generated by
#'   \code{\link[ggtree:ggtree]{ggtree}}
#' @param rel_width a numeric value. The relative width of a heatmap to the
#'   width the ggtree.
#' @importFrom ape as.phylo
#' @importFrom rlang .data
#' @importFrom dplyr '%>%' mutate
#' @importFrom data.table as.data.table melt
#' @keywords internal
#' @author Ruizhu Huang
#' @return a data frame
#'
.align_to_ggtree <- function(data, data_tree, rel_width = 1) {

    # the wide form of data
    data_wide <- as.data.table(data, keep.rownames = "rowLab")

    ## y, height are generated from data_tree
    # 1) y
    tree <- as.phylo(data_tree)
    desd_row <- .findOS(tree = tree, node = data_wide$rowLab,
                       only.leaf = FALSE, self.include = TRUE)
    y_row <- lapply(desd_row, FUN = function(x){
        xx <- match(x, data_tree$node)
        y <- data_tree$y[xx]
        # the middle point
        mean(range(y, na.rm = TRUE))
    })
    data_wide$y <- unlist(y_row)


    # 2) height
    h_row <- lapply(desd_row, FUN = function(x){
        xx <- match(x, data_tree$node)
        y <- data_tree$y[xx]

        cy <- colnames(data_tree)
        if ("scale" %in% cy) {
            dt <- unique(data_tree[["scale"]][xx])
            if (length(dt) > 1) {
                dt <- max(setdiff(dt, 1), 1)
            }
        } else {
            dt <- 1
        }
        # the distance
        diff(range(y, na.rm = TRUE)) + dt
    })
    data_wide$h <- unlist(h_row)

    # 3) width
    w <- rel_width*diff(range(data_tree$x, na.rm = TRUE))/ncol(data)
    data_long <- melt(data_wide, id.vars = c("y", "rowLab", "h"),
                      measure.vars = colnames(data),
                      variable.name = "colLab") %>%
        mutate(x = (as.numeric(factor(.data$colLab,
                                      levels = colnames(data)))-1)*w +
                   0.5*w,
               w = w)
     return(data_long)
}

# align_to_NULL <- function(data, rel_width = 1) {
#
#     # the wide form of data
#     data_wide <- data %>%
#         data.frame(check.names = FALSE) %>%
#         mutate(rowLab = rownames(data)) %>%
#         mutate(y = as.numeric(factor(rowLab))*1,
#                h = 1,
#                w = rel_width)
#
#     data_long <- gather(data_wide, key = "colLab", value = "value",
#                         - c(rowLab, y, h, w)) %>%
#         mutate(x = (as.numeric(factor(colLab))-1)*w)
#
#
#     return(data_long)
# }
#
#
# align_to_all <- function(data, data_tree, rel_width = 1) {
#
#     if (is.null(data_tree) |
#         is(data_tree, "waiver")) {
#         final <- align_to_NULL(data = data, rel_width = rel_width)
#     } else {
#         tree <- try(as.phylo(data_tree), silent = TRUE)
#         if (class(tree) %in% "try-error") {
#             stop("The main layer isn't a ggtree")
#         }
#         final <- align_to_ggtree(data = data, data_tree = data_tree,
#                                  rel_width = rel_width)
#     }
#
#     return(final)
#
#
# }
