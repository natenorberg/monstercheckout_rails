equipment = new Bloodhound(
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name')
  queryTokenizer: Bloodhound.tokenizers.whitespace
  prefetch: { url: '/equipment', cache: false }
)

users = new Bloodhound(
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name')
  queryTokenizer: Bloodhound.tokenizers.whitespace
  prefetch: { url: '/users', cache: false }
)

reservations = new Bloodhound(
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('project')
  queryTokenizer: Bloodhound.tokenizers.whitespace
  prefetch: { url: '/reservations', cache: false }
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
}, {
  name: 'reservations'
  display: 'project'
  source: reservations
  templates: header: '<h3 class="search-section">Reservations</h3>'
}
