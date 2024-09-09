function Span(el)

    local class_to_command = {
        {class = "alert", command = "alert"},
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

    local class_to_command = {
        {class = "fg", command = "fg"},
        {class = "bg", command = "bg"},
    }

    for _, mapping in ipairs(class_to_command) do
        if el.classes:includes(mapping.class) then
            local typst_command = "#" .. mapping.command
            local fill_value = el.attr.attributes["fill"]

            if fill_value then
                typst_command = typst_command .. "(fill: rgb(\"" .. fill_value .. "\"))"
            end

            local inlines = pandoc.List({
                pandoc.RawInline('typst', typst_command .. '['),
            })
            inlines:extend(el.content)
            inlines:insert(pandoc.RawInline('typst', ']'))
            return inlines
        end
    end

end