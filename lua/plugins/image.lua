-- lua/plugins/image.lua
-- Render images inline in the terminal (kitty graphics protocol), both embedded
-- in markdown and as standalone image files opened directly.
-- Pairs with render-markdown.nvim: that handles text decoration, this draws
-- the actual image files.

-- Zoom the image shown in the current (hijacked) buffer by rewriting its
-- geometry width in terminal cells. Height is left at 0 so image.nvim recomputes
-- it from the aspect ratio, keeping the picture undistorted. Small icons (ico)
-- render tiny by default because size is derived from native pixels; this gives
-- a manual way to scale them up.
local function zoom(factor)
  local buf = vim.api.nvim_get_current_buf()
  local img = (require("image").get_images { buffer = buf })[1]
  if not img then
    return
  end
  if factor == 0 then
    -- reset to the native, pixel-derived size
    img:render { width = 0, height = 0 }
    return
  end
  local cur = img.geometry.width or (img.rendered_geometry and img.rendered_geometry.width) or 20
  local new = math.floor(cur * factor + 0.5)
  -- guarantee at least one cell of change so tiny images still respond
  if new == cur then
    new = cur + (factor > 1 and 1 or -1)
  end
  img:render { width = math.max(1, new), height = 0 }
end

return {
  {
    "3rd/image.nvim",
    -- luarocks magick rock is avoided; the `magick_cli` processor shells out to
    -- the ImageMagick CLI (`magick`) which is already on PATH.
    build = false,
    -- load eagerly so the hijack autocmds are registered before an image file is
    -- opened (`nvim foo.svg`); ft-lazy would miss files opened directly, and ico
    -- has no filetype to trigger on. Same rationale as oil.nvim in this config.
    lazy = false,
    opts = {
      -- kitty terminal is in use ($TERM=xterm-kitty), which supports the
      -- graphics protocol natively.
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          -- keep every image drawn, not only the one under the cursor
          only_render_image_at_cursor = false,
          filetypes = { "markdown" },
        },
      },
      -- standalone image files opened directly are rendered via "hijack". The
      -- upstream default omits svg/ico/bmp even though ImageMagick (librsvg
      -- delegate) can convert them, so extend the list.
      hijack_file_patterns = {
        "*.png",
        "*.jpg",
        "*.jpeg",
        "*.gif",
        "*.webp",
        "*.avif",
        "*.svg",
        "*.ico",
        "*.bmp",
      },
      -- clamp very large images to the window so they don't dominate the buffer
      max_width_window_percentage = 50,
      max_height_window_percentage = 50,
      -- avoid flicker/leftover images while scrolling or moving windows
      window_overlap_clear_enabled = true,
    },
    config = function(_, opts)
      require("image").setup(opts)
      -- zoom keymaps only inside the standalone image viewer buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "image_nvim",
        callback = function(ev)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("+", function()
            zoom(1.2)
          end, "Image: zoom in")
          -- "-" is left to oil (open parent dir); use "_" for zoom out
          map("_", function()
            zoom(1 / 1.2)
          end, "Image: zoom out")
          map("0", function()
            zoom(0)
          end, "Image: reset zoom")
        end,
      })
    end,
  },
}
