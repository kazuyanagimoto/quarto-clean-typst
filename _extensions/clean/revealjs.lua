function HorizontalRule(el)
  -- Ignore horizontal rules in Typst format
  return pandoc.RawBlock("typst", "---")
end

function Div(el)
  if quarto.doc.is_format("typst") and el.classes:includes("incremental") then
    local modified_items = {}

    for i, item in ipairs(el.content) do
      if item.t == "BulletList" or item.t == "OrderedList" then
        for j, list_item in ipairs(item.content) do
          local modified_text = pandoc.utils.stringify(list_item[1])
          if j < #item.content then
            modified_text = modified_text .. " #pause"
          end
          list_item[1] = pandoc.RawInline('typst', modified_text)
        end
        table.insert(modified_items, item)
      else
        table.insert(modified_items, item)
      end
    end

    return pandoc.Div(modified_items, el.attr)
  end
end

function Para(el)
  if quarto.doc.is_format("typst") then
    local t = pandoc.utils.stringify(el)
    
    -- `. . .` as a pause
    if t:match("^%. ?%. ?%.$") then
      return pandoc.RawBlock("typst", "#pause")
    end
  end
end