if vim.g.started_by_firenvim == true then
    vim.g.firenvim_config.localSettings["https?://slack.com"] = { takeover = 'never', priority = 1 }
    vim.g.firenvim_config.localSettings["https?://mail.google.com"] = { takeover = 'never', priority = 1 }
end
