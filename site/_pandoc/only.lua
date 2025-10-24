-- only.lua: drop .only-jekyll, keep contents of .only-pandoc
-- Handles both native Div/Span nodes and raw HTML <div> wrappers.

local List = require 'pandoc.List'

local function has_class(classes, cls)
  return classes and List.includes(classes, cls)
end

-- Native block divs (Pandoc recognized <div class="..."> as Div)
function Div(el)
  if has_class(el.classes, 'only-jekyll') then
    return {}                  -- drop entirely
  elseif has_class(el.classes, 'only-pandoc') then
    return el.content          -- unwrap: keep inner blocks
  end
end

-- Native inline spans
function Span(el)
  if has_class(el.classes, 'only-jekyll') then
    return {}
  elseif has_class(el.classes, 'only-pandoc') then
    return el.content
  end
end

-- Fallback for raw HTML wrappers when Pandoc didn’t turn them into Divs.
function Pandoc(doc)
  local out = List()
  local mode = nil  -- nil | 'drop' | 'keep'

  local function is_open_of(txt, klass)
    -- match <div ... class="... klass ...">
    return txt:match('<div[^>]-class=[\'"][^\'"]-' .. klass .. '[^\'"]-[\'"]')
  end

  for _, blk in ipairs(doc.blocks) do
    if blk.t == 'RawBlock' and blk.format:match('html') then
      local t = blk.text
      if is_open_of(t, 'only%-jekyll') then
        mode = 'drop'   -- drop wrapper and its inner content
      elseif is_open_of(t, 'only%-pandoc') then
        mode = 'keep'   -- drop wrapper, keep inner content
      elseif t:match('</div>') and mode ~= nil then
        mode = nil
      else
        if not mode or mode == 'keep' then out:insert(blk) end
      end
    else
      if not mode then
        out:insert(blk)
      elseif mode == 'keep' then
        out:insert(blk)
      end
    end
  end

  return pandoc.Pandoc(out, doc.meta)
end
