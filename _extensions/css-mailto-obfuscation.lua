local css = [[
<style>
/* Avoiding Spam */
.obfuscated-mail-address::before {
  content: attr(data-user) "@" attr(data-domain);
  display: inline;
}
.obfuscated-mail-address > * {
  display: none;
}
</style>
]]

function Meta (meta)
  local header_includes = meta['header-includes']
  if pandoc.utils.type(header_includes) == 'nil' then
    header_includes = pandoc.List{}
  elseif pandoc.utils.type(header_includes) ~= 'List' then
    header_includes = pandoc.List{header_includes}
  end
  header_includes:insert({pandoc.RawBlock('html', css)})
  meta['header_includes'] = header_includes
  return meta
end

function Link (link)
  local user, domain = link.target:match 'mailto:([^%@]*)%@(.*)$'
  if user and domain then
    return pandoc.Span(
      pandoc.Emph 'obfuscated mail address',
      {
        ['class'] = 'obfuscated-mail-address',
        ['data-user'] = user,
        ['data-domain'] = domain
      }
    )
  end
end
