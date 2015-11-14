$("#matches tbody").empty();
<% for match in @matches %>
  $("#matches tbody").append($('<tr>')
    .append($('<td>').attr('class', 'match-home').text("<%== match.home.name %>"))
    .append($('<td>').attr('class', 'match-away').text("<%== match.away.name %>"))
    .append($('<td>').attr('class', 'match-predict').text("<%= match.predict %>"))
    .append($('<td>').attr('class', 'match-result').text("<%= match.result %>"))
    .append($('<td>').attr('class', 'match-date').text("<%= match.date %>"))
  );
<% end %>