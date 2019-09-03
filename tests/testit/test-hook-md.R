library(testit)

devtools::load_all()


style1 = "margin: 10px;"
style2 = "border-color: black;"
ex = sprintf("style='%s'", style1)
x = "1.png"
cap = "foo"
opt <- function(w = NULL, h =NULL, ex = NULL, show = 'asis', cap = NULL, ...) {
  list(out.width = w, out.height = h, out.extra = ex, fig.show = show, fig.cap = cap, ...)
}

h = hook_plot_md_pandoc
assert("Include plot as pandoc md", {
  (h(x, opt()) %==% "![](1.png)")
  (h(x, opt(w = 1)) %==% sprintf("![](1.png){width=%s}", 1))
  (h(x, opt(h = 1)) %==% sprintf("![](1.png){height=%s}", 1))
  (h(x, opt(cap = cap)) %==% sprintf("![%s](1.png)", cap))
  (h(x, opt(cap = cap), cap = "") %==% sprintf("![%s](1.png)", ""))
  (h(x, opt(ex = ex)) %==% sprintf("![](1.png){%s}", e))
  (h(x, opt(ex = c(ex, "width=1"))) %==% sprintf("![](1.png){%s width=1}", e))
  (h(x, opt(ex = ex), style = style2) %==% sprintf("![](1.png){style='%s%s'}", style2, style1))
  (h(x, opt(), style = style2) %==% sprintf("![](1.png){style='%s'}", style2))
})

