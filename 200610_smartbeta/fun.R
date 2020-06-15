plot_cumulative = function(R) {
  
  Date = key = value = NULL
  
  R = as.xts(R) %>%
    na.fill(0)
  R.cum = cumprod(1 + R) - 1
  
  R.cum = R.cum %>%
    data.frame() %>%
    rownames_to_column(var = 'Date') %>%
    mutate(Date = as.Date(Date)) %>%
    gather(key, value, -Date) %>%
    mutate(key = factor(key, levels = unique(key)))
  
  ggplot(R.cum, aes(x = Date, group = key, color = key)) +
    geom_line(aes(y = value)) +
    # ggtitle('Portfolio Cumulative Return') +
    xlab(NULL) +
    ylab(NULL) +
    theme_bw() +
    scale_x_date(date_breaks="years", date_labels="%Y",
                 expand = c(0, 0)) +
    theme(plot.title = element_text(hjust = 0.5,
                                    size = 12),
          legend.position = 'bottom',
          legend.title = element_blank()
          # axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
          # panel.grid.minor.x = element_blank()
          ) +
    guides(color = guide_legend(byrow = TRUE))
}

plot_yearly = function(R) {
  
  Date = key = value = NULL
  
  R = as.xts(R) %>%
    na.fill(0)
  
  R.yr = apply.yearly(R, Return.cumulative) %>%
    data.frame() %>%
    rownames_to_column(var = 'Date') %>%
    mutate(Date = year(Date)) %>%
    gather(key, value, -Date) %>%
    mutate(key = factor(key, levels = unique(key)))
  
  ggplot(R.yr, aes(x = Date, y = value, fill = key)) +
    geom_bar(position = "dodge", stat = "identity") +
    # ggtitle('Yearly Return') +
    # xlab(NULL) +
    # ylab(NULL) +
    # theme_bw() +
    scale_x_continuous(breaks = R.yr$Date,
                       expand = c(0.01, 0.01)) +
    theme(plot.title = element_text(hjust = 0.5,
                                    size = 12),
          legend.position = 'bottom',
          legend.title = element_blank(),
          legend.text = element_text(size=7),
          # axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
          panel.grid.minor.x = element_blank()
    ) +
    guides(fill = guide_legend(byrow = TRUE)) +
    geom_text(aes(label = paste(round(value * 100, 2), "%"),
                  vjust = ifelse(value >= 0, -0.5, 1.5)),
              position = position_dodge(width = 1),
              size = 3)
  
}


theme_set(theme_bw() +
            theme(axis.title.x=element_blank(),
                  axis.title.y=element_blank(),
                  legend.position = 'bottom',
                  legend.title = element_blank())
)

          