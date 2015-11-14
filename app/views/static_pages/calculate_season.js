$("#teams tbody").empty();
<% for team in @teams %>
  $("#teams tbody").append($('<tr>')
    .append($('<td>').attr('class', 'team-name').text("<%== team.name %>"))
    .append($('<td>').attr('class', 'team-current-rating').text("<%= team.mean.round(2).to_s + ' ±' + team.standard_deviation.round(2).to_s %>"))
    .append($('<td>').attr('class', 'team-old-rating').text("<%= team.old_mean.round(2).to_s + ' ±' + team.old_standard_deviation.round(2).to_s %>"))
  );
<% end %>