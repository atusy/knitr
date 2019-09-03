library(testit)

w = h = 1
style1 = "margin: 10px;"
style2 = "border-color: black;"
ex = sprintf("style='%s'", style1)
x = "1.png"
cap = "foo"
link = "link"
opt <- function(w = NULL, h =NULL, ex = NULL, show = 'asis', cap = NULL, align = "default", link = NULL, ...) {
  list(out.width = w, out.height = h, out.extra = ex, fig.show = show, fig.cap = cap, fig.align = align, fig.link = link, ...)
}

hook = hook_plot_md_pandoc
assert("Include plot as pandoc md", {
  (hook(x, opt()) %==% "![](1.png)")
  (hook(x, opt(w = w)) %==% sprintf("![](1.png){width=%s}", w))
  (hook(x, opt(h = h)) %==% sprintf("![](1.png){height=%s}", h))
  (hook(x, opt(cap = cap)) %==% sprintf("![%s](1.png)", cap))
  (hook(x, opt(cap = cap), cap = "") %==% sprintf("![%s](1.png)", ""))
  (hook(x, opt(ex = ex)) %==% sprintf("![](1.png){%s}", ex))
  (hook(x, opt(ex = c(ex, "width=1"))) %==% sprintf("![](1.png){%s width=1}", ex))
  (hook(x, opt(ex = ex), style = style2) %==% sprintf("![](1.png){style='%s%s'}", style2, style1))
  (hook(x, opt(), style = style2) %==% sprintf('![](1.png){style="%s"}', style2))
})

align = 'left'

hook = hook_plot_md_base
assert("hook_plot_md_base", {
  # width, height, and extra are null, and align is default
  (hook(x, opt()) %==% "![](1.png)")
  (hook(x, opt(cap = cap)) %==% sprintf("![%s](1.png)", cap))
  (hook(x, opt(link = link)) %==% sprintf("[![](1.png)](%s)", link))
  opts_knit$set(rmarkdown.pandoc.to = 'latex')
  (hook(x, opt(cap = '')) %==% "![](1.png)<!-- --> ")
  opts_knit$set(rmarkdown.pandoc.to = 'html')
  (hook(x, opt(cap = '')) %==% "![](1.png)<!-- -->")
  # html output with caption or width
  (hook(x, opt(align = align, cap = cap)) %==%
      sprintf('<div class="figure" style="text-align: %s">\n![%s](1.png)\n<p class="caption">%s</p>\n</div>', align, cap, cap))
  ## add link
  (hook(x, opt(w = w, cap = cap, link = link)) %==%
      sprintf('<div class="figure">\n[![%s](1.png){width=%s}](%s){target="_blank"}\n<p class="caption">%s</p>\n</div>', cap, w, link, cap))
  ## fig.caption is TRUE
  (hook(x, opt(w = w, cap = cap, fig.topcaption = TRUE)) %==%
      sprintf('<div class="figure">\n<p class="caption">%s</p>![%s](1.png){width=%s}</div>', cap, cap, w))
  ## plot1 is FALSE
  (hook(x, opt(w = w, cap = cap, show = 'hold', fig.cur = 2, fig.num = 2)) %==%
      sprintf('![%s](1.png){width=%s}\n<p class="caption">%s</p>\n</div>', cap, w, cap))
  ## plot2 is FALSE
  (hook(x, opt(w = w, cap = cap, show = 'hold', fig.cur = 1, fig.num = 2)) %==%
      sprintf('<div class="figure">\n![%s](1.png){width=%s}', cap, w, cap))
  # else
  opts_knit$restore()
  (hook(x, opt(align = 'center')) %==% '![](1.png){style="display: block; margin: auto;"}')
})
