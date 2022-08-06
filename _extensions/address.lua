function Div (div)
  if #div.classes == 1 and div.classes[1] == 'address' then
    local address = div.content
    if #address == 1 and address[1].t == 'Para' then
      address = pandoc.Blocks{pandoc.Plain(address[1].content)}
    elseif #address == 1 and address[1].t == 'LineBlock' then
      local lines = pandoc.Inlines{}
      for i, line in ipairs(address[1].content) do
        lines:extend(line)
        lines:insert(pandoc.RawInline('html', '<br/>'))
      end
      address = pandoc.Blocks{pandoc.Plain(lines)}
    end
    return
      {pandoc.RawBlock('html', '<address>')} ..
      address ..
      {pandoc.RawBlock('html', '</address>')}
  end
end
