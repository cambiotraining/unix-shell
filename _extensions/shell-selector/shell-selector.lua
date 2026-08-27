local assets_included = false

local function include_assets()
  if not assets_included then
    quarto.doc.include_file(
      "in-header",
      quarto.utils.resolve_path("shell-selector.html")
    )
    assets_included = true
  end
end

local function shell_selector(args, kwargs, meta, raw_args, context)
  include_assets()

  local classes = "shell-selector"

  if args[1] == "center" then
    classes = classes .. " shell-selector-center"
  end

  local html = string.format([[
<div class="%s" role="group" aria-label="Select your shell">
  <button type="button"
          class="shell-selector-button"
          data-shell-select="bash"
          aria-pressed="false">
    Bash
  </button>
  <button type="button"
          class="shell-selector-button"
          data-shell-select="zsh"
          aria-pressed="false">
    Zsh
  </button>
</div>
]], classes)

  if context == "block" then
    return pandoc.RawBlock("html", html)
  else
    return pandoc.RawInline("html", html)
  end
end

local function shell_file(args, kwargs, meta, raw_args, context)
  include_assets()

  return pandoc.Str("__QUARTO_SHELL_FILE__")
end

return {
  ["shell-selector"] = shell_selector,
  ["shell-file"] = shell_file
}