$("#matches tbody").empty();
$("#teams tbody").empty();
<% for team in @teams %>
  $("#teams tbody").append($('<tr>')
    .append($('<td>').attr('class', 'team-name').text("<%== team.name %>"))
    .append($('<td>').attr('class', 'team-current-rating').text("<%= team.mean.round(2).to_s + ' ±' + team.standard_deviation.round(2).to_s %>"))
    .append($('<td>').attr('class', 'team-old-rating').text(""))
  );
<% end %>
<% if session[:current_year] >= 1993 %>
  $("#current-season").text('Season: ' + "<%= session[:current_year] %>" + '-' + "<%= session[:current_year] + 1 %>");
<% else %>
  $("#current-season").text('');
<% end %>
$("#load-data").text('Load data for season ' + "<%= session[:current_year] + 1 %>" + '-' + "<%= session[:current_year] + 2 %>");
$("#load-data").prop("disabled", "<%= session[:calculated] %>" == 'true' ? false : true);
$("#calculate-season").prop("disabled", "<%= session[:calculated] %>" == 'true' ? true : false);
