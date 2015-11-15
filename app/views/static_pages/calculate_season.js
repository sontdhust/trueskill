$("#teams tbody").empty();
<% for team in @teams %>
  $("#teams tbody").append($('<tr>')
    .append($('<td>').prop('class', 'team-name').text("<%== team.name %>"))
    .append($('<td>').prop('class', 'team-current-rating').text("<%= team.mean.round(2).to_s + ' ±' + team.standard_deviation.round(2).to_s %>"))
    .append($('<td>').prop('class', 'team-old-rating').text("<%= team.old_mean.round(2).to_s + ' ±' + team.old_standard_deviation.round(2).to_s %>"))
  );
<% end %>
$("#load-data").text('Load data for season ' + "<%= session[:current_year] + 1 %>" + '-' + "<%= session[:current_year] + 2 %>");
<% if session[:current_year] == 2015 %>
  $("#load-data").prop("disabled", true);
  $("#calculate-season").prop("disabled", true);
<% else %>
  $("#load-data").prop("disabled", "<%= session[:calculated] %>" == 'true' ? false : true);
  $("#calculate-season").prop("disabled", "<%= session[:calculated] %>" == 'true' ? true : false);
<% end %>
