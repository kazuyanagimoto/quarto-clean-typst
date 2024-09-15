local classEnvironments = pandoc.MetaMap({
    ["only"] = "only",
    ["uncover"] = "uncover",
})
local classCommands = pandoc.MetaMap({
    ["alert"] = "alert",
    ["fg"] = "fg",
    ["bg"] = "bg",
    ["button"] = "button",    
    ["only"] = "only",
    ["uncover"] = "uncover",
})

-- helper that identifies arrays
local function tisarray(t)
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then return false end
  end
  return true
end

-- reads the environments
local function readEnvironments(meta)
  local env = meta['environments']
  if env ~= nil then
    if tisarray(env) then
      -- read an array of strings
      for i, v in ipairs(env) do
        local value = pandoc.utils.stringify(v)
        classEnvironments[value] = value
      end
    else
      -- read key value pairs
      for k, v in pairs(env) do
        local key = pandoc.utils.stringify(k)
        local value = pandoc.utils.stringify(v)
        classEnvironments[key] = value
      end
    end
  end
end

local function readCommands(meta)
  local env = meta['commands']
  if env ~= nil then
    if tisarray(env) then
      -- read an array of strings
      for i, v in ipairs(env) do
        local value = pandoc.utils.stringify(v)
        classCommands[value] = value
      end
    else
      -- read key value pairs
      for k, v in pairs(env) do
        local key = pandoc.utils.stringify(k)
        local value = pandoc.utils.stringify(v)
        classCommands[key] = value
      end
    end
  end
end

local function readEnvsAndCommands(meta)
  readEnvironments(meta)
  readCommands(meta)
end

local function endTypstBlock(blocks)
    local lastBlock = blocks[#blocks]
    if lastBlock.t == "Para" or lastBlock.t == "Plain" then
        lastBlock.content:insert(pandoc.RawInline('typst', '\n]'))
        return blocks
    else
        blocks:insert(pandoc.RawBlock('typst', ']\n'))
        return blocks
    end
end


local function writeEnvironments(el)
  if quarto.doc.is_format("typst") then
    for k, v in pairs(classEnvironments) do
      if el.attr.classes:includes(k) then

        local blocks = pandoc.List({
            pandoc.RawBlock('typst', '#' .. pandoc.utils.stringify(v) .. '('),
        })
        local opts = el.attr.attributes['options']
        if opts then
          blocks:insert(pandoc.RawBlock('typst', opts))
        end
        blocks:insert(pandoc.RawBlock('typst', ')['))
        blocks:extend(el.content)
        return endTypstBlock(blocks)
      end
    end

     if el.classes:includes("complex-anim") then
        local repeat_value = el.attr.attributes["repeat"]
        local typst_command = "#slide(repeat: " .. repeat_value .. ", self => [\n#let (uncover, only, alternatives) = utils.methods(self)"
        local blocks = pandoc.List({
            pandoc.RawBlock('typst', typst_command),
        })
        blocks:extend(el.content)
        blocks:insert(pandoc.RawBlock('typst', '\n])'))
        return blocks
    end
  end
end

local function writeCommands(el)
  if quarto.doc.is_format("typst") then
    for k, v in pairs(classCommands) do
      if el.attr.classes:includes(k) then

        local inlines = pandoc.List({
            pandoc.RawInline('typst', '#' .. pandoc.utils.stringify(v) .. '('),
        })
        local opts = el.attr.attributes['options']
        if opts then
          inlines:insert(pandoc.RawInline('typst', opts))
        end
        inlines:insert(pandoc.RawInline('typst', ')['))
        inlines:extend(el.content)
        inlines:insert(pandoc.RawInline('typst', ']'))
        return inlines
      end
    end
  end
end

-- Run in two passes so we process metadata
-- and then process the divs
return {
  { Meta = readEnvsAndCommands },
  { Div = writeEnvironments, Span = writeCommands }
}