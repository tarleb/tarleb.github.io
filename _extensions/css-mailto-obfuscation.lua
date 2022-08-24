local js = [[
<script type="text/javascript">
window.document.addEventListener('DOMContentLoaded', _ => {
    const mailAddressClass = 'obfuscated-mail-address';
    window.document.querySelectorAll('.' + mailAddressClass).forEach(el => {
      const address = [
          el.getAttribute('data-user') || '',
          '@',
          el.getAttribute('data-domain') || ''
      ].join('');
      const link = window.document.createElement('a');
      link.setAttribute('href', 'mailto:' + address);
      link.textContent = address;
      el.replaceChildren(link);
      el.classList.remove(mailAddressClass);
  });
});
</script>
]]

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

local stringify = pandoc.utils.stringify
local has_mail = false

local function Meta (meta)
  if not has_mail then
    return nil
  end
  local header_includes = meta['header-includes']
  if pandoc.utils.type(header_includes) == 'nil' then
    header_includes = pandoc.List{}
  elseif pandoc.utils.type(header_includes) ~= 'List' then
    header_includes = pandoc.List{header_includes}
  end
  header_includes:insert({pandoc.RawBlock('html', css)})
  header_includes:insert({pandoc.RawBlock('html', js)})
  meta['header_includes'] = header_includes
  return meta
end

local function Link (link)
  local user, domain = link.target:match 'mailto:([^%@]*)%@(.*)$'
  if user and domain and stringify(link.content) == link.target then
    has_mail = true
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

return {
  {Link = Link},
  {Meta = Meta}
}
