
.current_heatmap <- function(plot, object) {
    current <- object$th_params$name
    if (is.null(current)) {
        current <- length(plot$heatmap)
    } else {
        if (!current %in% names(plot$heatmap)) {
            stop(current, " can't be found")
        }
    }
    return(current)
}


.row_anchor <- function(plot, current){
    plot$heatmap[[current]]$row_anchor
}
.col_anchor <- function(plot, current){
    plot$heatmap[[current]]$col_anchor
}
.hm_data <- function(plot, current){
    plot$heatmap[[current]]$data
}
.col_tree <- function(plot, current){
    plot$heatmap[[current]]$col_tree
}

.row_axis <- function(plot, current){
    plot$heatmap[[current]]$row_tmp$df_axis
}

.col_axis <- function(plot, current){
    plot$heatmap[[current]]$col_tmp$df_axis
}

.col_axis <- function(plot, current){
    plot$heatmap[[current]]$col_tmp$df_axis
}
