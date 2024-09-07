function Span(el)

    local class_to_command = {
        {class = "alert", command = "alert"},
        {class = "fg", command = "fg"},
        {class = "bg", command = "bg"},
        {class = "button", command = "button"},
        {class = "small-cite", command = "small-cite"},
    }

    for _, mapping in ipairs(class_to_command) do
        if el.classes:includes(mapping.class) then
            local inlines = pandoc.List({
                pandoc.RawInline('typst', '#' .. mapping.command .. '['),
            })
            inlines:extend(el.content)
            inlines:insert(pandoc.RawInline('typst', ']'))
            return inlines
        end
    end


    if el.classes:includes('label') then
        local inlines = pandoc.List({
            pandoc.RawInline('typst', '#label("'),
        })
        inlines:extend(el.content)
        inlines:insert(pandoc.RawInline('typst', '")'))
        return inlines
    end
end