function appendix()
    return pandoc.RawBlock('typst', '#show: appendix')
end

function pause()
    return pandoc.RawBlock('typst', '#pause')
end

function meanwhile()
    return pandoc.RawBlock('typst', '#meanwhile')
end

function v(args)
    return pandoc.RawInline('typst', '#v(' .. args[1] .. ')')
end