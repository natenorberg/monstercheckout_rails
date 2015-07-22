equipment = new Bloodhound(
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name')
  queryTokenizer: Bloodhound.tokenizers.whitespace
  prefetch: '/equipment'
)

users = new Bloodhound(
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name')
  queryTokenizer: Bloodhound.tokenizers.whitespace
  prefetch: '/users'
)

$('#search_input_group input').typeahead { highlight: true }, {
  name: 'equipment'
  display: 'name'
  source: equipment
  templates: header: '<h3 class="search-section">Equipment</h3>'
}, {
  name: 'users'
  display: 'name'
  source: users
  templates: header: '<h3 class="search-section">Users</h3>'
}
